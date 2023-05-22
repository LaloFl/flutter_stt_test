void main() {
  Map<String, dynamic> mainCmds = {
    "ejecutar": {
      "alias": [
        "ejecutar",
        "ejecuta",
        "ejecútame",
        "hacer",
        "haz",
        "hazme",
        "calcular",
        "calcula",
        "calcúlame",
        "cálculo",
        "execute",
        "do",
        "make",
        "calculate",
      ],
    },
  };

  Map<String, dynamic> execCmds = {
    "simulacion": {
      "alias": [
        "simulación",
        "simulacion",
        "simular",
        "simula",
        "simulation",
        "simulate",
      ],
    },
  };

  String str = "make a simulation for 50,000 please";

  List<String> parsedStrList = str.replaceAll(",", "").toLowerCase().split(" ");

  String mainCmd = "";
  String execCmd = "";

  // GET MAIN COMMAND
  for (var cmd in mainCmds.values) {
    if (parsedStrList.any((element) {
      mainCmd = element;
      return cmd["alias"].contains(element);
    })) {
      print("main command recognized $mainCmd");
    }

    // GET KEY OF MAIN COMMAND
    for (var key in mainCmds.keys) {
      if (mainCmds[key]["alias"].contains(mainCmd)) {
        mainCmd = key;
        print("main command key recognized $key");
      }
    }
  }

  // GET EXEC COMMAND
  for (var cmd in execCmds.values) {
    if (parsedStrList.any((element) {
      execCmd = element;
      return cmd["alias"].contains(element);
    })) {
      print("exec command recognized $execCmd");
    }

    // GET KEY OF EXEC COMMAND
    for (var key in execCmds.keys) {
      if (execCmds[key]["alias"].contains(execCmd)) {
        execCmd = key;
        print("exec command key recognized $key");
      }
    }
  }

  // GET ARGS FOR EXEC COMMAND
  List<String> args = [];
  for (var i = 0; i < parsedStrList.length; i++) {
    if (double.tryParse(parsedStrList[i]) != null) {
      args.add(parsedStrList[i]);
    }
  }
  print("args: $args");

  // FINAL COMMAND WITH ARGS
  String finalCmd = "$mainCmd $execCmd $args";
  print(finalCmd);

  // GET RESULT
  switch (mainCmd) {
    case "ejecutar":
      switch (execCmd) {
        case "":
          break;
        case "suma":
          print(
              "result: ${args.map((e) => double.parse(e)).reduce((a, b) => a + b)}");
          break;
        default:
      }
      break;
    default:
      print("no command recognized");
      break;
  }
}
