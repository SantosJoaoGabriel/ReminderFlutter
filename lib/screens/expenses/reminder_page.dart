import 'package:financing_app/models/reminder.dart';
import 'package:financing_app/services/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financing_app/services/weather_service.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final ReminderService _service = ReminderService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weatherController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  void _showReminderDialog({Reminder? reminder}) {
  if (reminder != null) {
    _titleController.text = reminder.title;
    _descriptionController.text = reminder.description;
    _weatherController.text = reminder.weather;
    _selectedDate = reminder.date;
  } else {
    _titleController.clear();
    _descriptionController.clear();
    _weatherController.clear();
    _selectedDate = null;
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(reminder != null ? 'Editar Lembrete' : 'Novo Lembrete'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => v != null && v.isNotEmpty ? null : 'Informe o título',
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) => v != null && v.isNotEmpty ? null : 'Informe a descrição',
            ),
            ListTile(
              title: Text(_selectedDate == null
                ? 'Escolha a data'
                : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                var picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'), 
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate() || _selectedDate == null) return;

            // Chamada para a WeatherAPI - aqui acontece a integração automática!
            String cidade = "São Paulo"; // ou use um campo do usuário
            String clima = await WeatherService().getWeatherDescription(
              city: cidade,
              date: _selectedDate!,
            );

            final newReminder = Reminder(
              id: reminder?.id ?? '', // Firestore irá gerar id se vazio
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              weather: clima, // agora preenchido automaticamente!
              date: _selectedDate!,
            );

            if (reminder == null) {
              await _service.addReminder(newReminder);
            } else {
              await _service.updateReminder(reminder.id, newReminder.copyWith(id: reminder.id));
            }

            Navigator.pop(context);
          },
          child: Text(reminder != null ? 'Salvar' : 'Adicionar'),
        )
      ]
    )
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Reminder>>(
        stream: _service.getReminders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reminders = snapshot.data ?? [];

          if (reminders.isEmpty) {
            return const Center(child: Text('Nenhum lembrete cadastrado'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text (
                    reminder.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reminder.description,
                        style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text('Clima: ${reminder.weather}',
                        style: const TextStyle(fontSize: 15)),
                      Text(
                        'Data: ${DateFormat('dd/MM/yyyy').format(reminder.date)}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showReminderDialog(reminder: reminder),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _service.deleteReminder(reminder.id),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}

extension on Reminder {
  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    String? weather,
    DateTime? date,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      weather: weather ?? this.weather,
      date: date ?? this.date,
    );
  }
}