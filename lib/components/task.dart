import 'package:flutter/material.dart';
import 'package:primeiro_projeto/components/difficulty.dart';
import 'package:primeiro_projeto/data/task_dao.dart';

class Task extends StatefulWidget {
  final String nome;
  final String foto;
  final int dificuldade;

  Task(this.nome, this.foto, this.dificuldade, this.nivel, {Key? key})
      : super(key: key);

  Task getTask() {
    return Task(this.nome, this.foto, this.dificuldade, this.nivel);
  }

  int nivel = 0;
  int maestria = 0;
  double valor = 0;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool assetOrNetwork() {
    if (widget.foto.contains('http')) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: (widget.maestria == 0)
                      ? (Colors.blue)
                      : ((widget.maestria == 1)
                          ? (Colors.green)
                          : (((widget.maestria == 2)
                              ? (Colors.purple)
                              : ((widget.maestria == 3)
                                  ? (Colors.amber)
                                  : ((widget.maestria == 4)
                                      ? (Colors.red)
                                      : (Colors.red)))))),
                )),
            Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.black26,
                            ),
                            width: 72,
                            height: 100,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: assetOrNetwork()
                                    ? Image.asset(widget.foto,
                                        fit: BoxFit.cover)
                                    : Image.network(widget.foto,
                                        fit: BoxFit.cover))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                widget.nome,
                                style: const TextStyle(
                                    fontSize: 24,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Difficulty(
                              difficultyLevel: widget.dificuldade,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: ElevatedButton(
                              onLongPress: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Deletando tarefa'),
                                        content: Text(
                                            'Deseja deletar a tarefa ${widget.nome}?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Não'),
                                            child: const Text('Não'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              TaskDao().delete(widget.nome);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Deletando tarefa! Atualize a página.')));
                                              Navigator.pop(context, 'Sim');
                                            },
                                            child: const Text('Sim'),
                                          )
                                        ],
                                      )),

                              //     (){TaskDao().delete(widget.nome);
                              onPressed: () {
                                setState(() {
                                  aumentoMaestria();
                                });
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Icon(Icons.arrow_drop_up),
                                  Text(
                                    'Up',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                              color: Colors.white,
                              value: (widget.dificuldade > 0)
                                  ? widget.nivel / (widget.dificuldade * 10)
                                  : 1),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Nível: ${widget.nivel}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }

  void aumentoMaestria() {
    widget.nivel++;
    TaskDao().updateLevel(widget.getTask());
    if (widget.maestria > 4) {
      widget.maestria -= 5;
    }
    return setState(() {
      if (widget.nivel / (widget.dificuldade * 10) == 1) {
        widget.maestria++;
        widget.nivel = 0;
      }
    });
  }
}
