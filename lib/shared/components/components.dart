import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.type,
    required this.validateFunc,
    required this.label,
    required this.prefix,
    this.onChange,
    this.isSecure = false,
    this.onSuffixPressed,
    this.suffix,
    this.onSubmit,
    this.onFieldTap,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType type;
  final String? Function(String?)? validateFunc;
  final Function? onSuffixPressed;
  final Function? onChange, onSubmit, onFieldTap;
  final String label;
  final IconData prefix;
  final IconData? suffix;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validateFunc,
      obscureText: isSecure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: () {
                  onSuffixPressed!();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: (value) {
        if (onChange != null) {
          onChange!();
        }
      },
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit!(value);
        }
      },
      onTap: () {
        if (onFieldTap != null) {
          onFieldTap!();
        }
      },
    );
  }
}

class CustomTaskItem extends StatelessWidget {
  const CustomTaskItem({
    Key? key,
    required this.taskTime,
    required this.taskTitle,
    required this.taskDate,
  }) : super(key: key);
  final String? taskTime, taskTitle, taskDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 40.0,
            child: Text(
              taskTime!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskTitle!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                taskDate!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
