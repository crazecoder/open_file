String parseArgs(List<String> args) {
    final commandList = args
        .map(
          (arg) => arg
              .replaceAll(' ', '\\ ')
              .replaceAll('(', '\\(')
              .replaceAll(')', '\\)'),
        )
        .toList();

    return commandList.join(' ');
  }
