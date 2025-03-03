import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization(null);
  runApp(const MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PadLive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PadLive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Função para mostrar o pad e o LED

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Inicializando o timer
    _ledTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _ledState = !_ledState;
      });
    });
  }

  bool _ledState = false; // Estado do LED
  late Timer? _ledTimer; // Timer para alternar o estado do LED
  bool isTransitioning = false; // Controle de transição
  double currentVolume = 0.5; // Volume inicial

  // Notas naturais
  final cAudioPlayer = AudioPlayer();
  bool cAudioPlayer_bool = false;

  final dAudioPlayer = AudioPlayer();
  bool dAudioPlayer_bool = false;

  final eAudioPlayer = AudioPlayer();
  bool eAudioPlayer_bool = false;

  final fAudioPlayer = AudioPlayer();
  bool fAudioPlayer_bool = false;

  final gAudioPlayer = AudioPlayer();
  bool gAudioPlayer_bool = false;

  final aAudioPlayer = AudioPlayer();
  bool aAudioPlayer_bool = false;

  final bAudioPlayer = AudioPlayer();
  bool bAudioPlayer_bool = false;

// Notas sustenidas
  final cSustenidoAudioPlayer = AudioPlayer();
  bool cSustenidoAudioPlayer_bool = false;

  final dSustenidoAudioPlayer = AudioPlayer();
  bool dSustenidoAudioPlayer_bool = false;

  final fSustenidoAudioPlayer = AudioPlayer();
  bool fSustenidoAudioPlayer_bool = false;

  final gSustenidoAudioPlayer = AudioPlayer();
  bool gSustenidoAudioPlayer_bool = false;

  final aSustenidoAudioPlayer = AudioPlayer();
  bool aSustenidoAudioPlayer_bool = false;

  final pad_c = AudioPlayer();
  bool pad_c_bool = false;

  final pad_c_sustenido = AudioPlayer();
  bool pad_c_sustenido_bool = false;

  final pad_d = AudioPlayer();
  bool pad_d_bool = false;

  final pad_eb = AudioPlayer();
  bool pad_eb_bool = false;

  final pad_e = AudioPlayer();
  bool pad_e_bool = false;

  final pad_f = AudioPlayer();
  bool pad_f_bool = false;

  final pad_gb = AudioPlayer();
  bool pad_gb_bool = false;

  final pad_g = AudioPlayer();
  bool pad_g_bool = false;

  final pad_ab = AudioPlayer();
  bool pad_ab_bool = false;

  final pad_a = AudioPlayer();
  bool pad_a_bool = false;

  final pad_bb = AudioPlayer();
  bool pad_bb_bool = false;

  final pad_b = AudioPlayer();
  bool pad_b_bool = false;

  @override
  void dispose() {
    // Parar todos os players
    cAudioPlayer.stop();
    dAudioPlayer.stop();
    eAudioPlayer.stop();
    fAudioPlayer.stop();
    gAudioPlayer.stop();
    aAudioPlayer.stop();
    bAudioPlayer.stop();

    cSustenidoAudioPlayer.stop();
    dSustenidoAudioPlayer.stop();
    fSustenidoAudioPlayer.stop();
    gSustenidoAudioPlayer.stop();
    aSustenidoAudioPlayer.stop();

    // Liberar recursos dos players
    cAudioPlayer.dispose();
    dAudioPlayer.dispose();
    eAudioPlayer.dispose();
    fAudioPlayer.dispose();
    gAudioPlayer.dispose();
    aAudioPlayer.dispose();
    bAudioPlayer.dispose();

    cSustenidoAudioPlayer.dispose();
    dSustenidoAudioPlayer.dispose();
    fSustenidoAudioPlayer.dispose();
    gSustenidoAudioPlayer.dispose();
    aSustenidoAudioPlayer.dispose();

    // Chamar super.dispose uma única vez
    _ledTimer?.cancel(); // Cancelar o Timer do LED
    super.dispose();
  }

  // Função para ajustar o volume do pad ativo
  void _adjustVolume(double volume) {
    setState(() {
      currentVolume = volume;
    });

    cAudioPlayer.setVolume(volume);
    cSustenidoAudioPlayer.setVolume(volume);
    dAudioPlayer.setVolume(volume);
    dSustenidoAudioPlayer.setVolume(volume);
    eAudioPlayer.setVolume(volume);
    fAudioPlayer.setVolume(volume);
    fSustenidoAudioPlayer.setVolume(volume);
    gAudioPlayer.setVolume(volume);
    gSustenidoAudioPlayer.setVolume(volume);
    aAudioPlayer.setVolume(volume);
    aSustenidoAudioPlayer.setVolume(volume);
    bAudioPlayer.setVolume(volume);
  }

  // Função para aumentar o volume com os botões
  void _increaseVolume(AudioPlayer currentAudioPlayer) {
    setState(() {
      currentVolume =
          (currentVolume + 0.1).clamp(0.0, 1.0); // Limita o volume entre 0 e 1
    });
    currentAudioPlayer.setVolume(currentVolume);
  }

  // Função para diminuir o volume com os botões
  void _decreaseVolume(AudioPlayer currentAudioPlayer) {
    setState(() {
      currentVolume = (currentVolume - 0.1).clamp(0.0, 1.0);
    });
    currentAudioPlayer.setVolume(currentVolume);
  }

  Future<void> _fadeOutCurrentPad(AudioPlayer currentAudioPlayer) async {
    for (double i = currentAudioPlayer.volume; i >= 0; i -= 0.1) {
      await Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentAudioPlayer.setVolume(i);
        });
        print(
            "Diminuindo volume de : ${currentAudioPlayer.source}, ${currentAudioPlayer.volume}");
      });
    }
    currentAudioPlayer.stop();
  }

  Future<void> _fadeInNewPad(AudioPlayer newAudioPlayer) async {
    // Faz fade-in do novo áudio
    for (double i = 0; i <= currentVolume; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          newAudioPlayer.setVolume(i);
        });
        print("Aumentando volume: ${newAudioPlayer.volume}");
      });
    }
  }

  void _playNewPad(AudioPlayer newAudioPlayer, String audioPath) {
    // Inicia o fade-in do novo áudio

    newAudioPlayer.play(AssetSource(audioPath)); // Toca o áudio
    _fadeInNewPad(newAudioPlayer); // Aplica o fade-in
  }

  void _togglePad(String padName, AudioPlayer audioPlayer) {
    // Verificação das notas naturais e seus booleans
    if (padName == "C" && cAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      cAudioPlayer_bool = false;
    } else if (padName == "C#" && cSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      cSustenidoAudioPlayer_bool = false;
    } else if (padName == "D" && dAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      dAudioPlayer_bool = false;
    } else if (padName == "D#" && dSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      dSustenidoAudioPlayer_bool = false;
    } else if (padName == "E" && eAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      eAudioPlayer_bool = false;
    } else if (padName == "F" && fAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      fAudioPlayer_bool = false;
    } else if (padName == "F#" && fSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      fSustenidoAudioPlayer_bool = false;
    } else if (padName == "G" && gAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      gAudioPlayer_bool = false;
    } else if (padName == "G#" && gSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      gSustenidoAudioPlayer_bool = false;
    } else if (padName == "A" && aAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      aAudioPlayer_bool = false;
    } else if (padName == "A#" && aSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      aSustenidoAudioPlayer_bool = false;
    } else if (padName == "B" && bAudioPlayer_bool) {
      _fadeOutCurrentPad(audioPlayer);
      bAudioPlayer_bool = false;
    } else {
      // Se o pad não está tocando, toca o áudio normalmente com fade-in
      _handlePadPress(padName, audioPlayer);
    }
  }

  // Função que alterna o estado do LED a cada 1 segundo
  // Função que alterna o estado do LED a cada 1 segundo
  void _toggleLed() {
    if (_isAnyPlayerActive()) {
      // Se há algum player ativo e o timer não está rodando, cria um novo timer
      if (_ledTimer == null || !_ledTimer!.isActive) {
        _ledTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _ledState = !_ledState; // Alterna o estado do LED a cada 1 segundo
          });
        });
      }
    } else {
      // Se nenhum player estiver ativo, desliga o LED e cancela o timer
      if (_ledTimer != null && _ledTimer!.isActive) {
        _ledState = false; // Desliga o LED
        _ledTimer!.cancel(); // Cancela o timer
        _ledTimer = null; // Limpa o timer
        setState(() {}); // Atualiza a interface para refletir a mudança
      }
    }
  }

  void _handlePadPress(String padName, AudioPlayer newAudioPlayer) {
    if (isTransitioning) {
      // Ignorar o clique durante a transição
      print("Transição em andamento, ação ignorada.");
      return;
    }

    setState(() {
      isTransitioning = true; // Bloqueia outras ações
    });
    String audioPath = "";

    // Verifica qual pad está tocando e para o áudio
    if (cAudioPlayer_bool) {
      _fadeOutCurrentPad(cAudioPlayer);
      cAudioPlayer_bool = false;
    }
    if (cSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(cSustenidoAudioPlayer);
      cSustenidoAudioPlayer_bool = false;
    }
    if (dAudioPlayer_bool) {
      _fadeOutCurrentPad(dAudioPlayer);
      dAudioPlayer_bool = false;
    }
    if (dSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(dSustenidoAudioPlayer);
      dSustenidoAudioPlayer_bool = false;
    }
    if (eAudioPlayer_bool) {
      _fadeOutCurrentPad(eAudioPlayer);
      eAudioPlayer_bool = false;
    }
    if (fAudioPlayer_bool) {
      _fadeOutCurrentPad(fAudioPlayer);
      fAudioPlayer_bool = false;
    }
    if (fSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(fSustenidoAudioPlayer);
      fSustenidoAudioPlayer_bool = false;
    }
    if (gAudioPlayer_bool) {
      _fadeOutCurrentPad(gAudioPlayer);
      gAudioPlayer_bool = false;
    }
    if (gSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(gSustenidoAudioPlayer);
      gSustenidoAudioPlayer_bool = false;
    }
    if (aAudioPlayer_bool) {
      _fadeOutCurrentPad(aAudioPlayer);
      aAudioPlayer_bool = false;
    }
    if (aSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(aSustenidoAudioPlayer);
      aSustenidoAudioPlayer_bool = false;
    }
    if (bAudioPlayer_bool) {
      _fadeOutCurrentPad(bAudioPlayer);
      bAudioPlayer_bool = false;
    }

    // Define o caminho do áudio correspondente ao pad clicado
    if (padName == "C") {
      audioPath = "foundations/c.mp3"; // Caminho do áudio para o pad C
      cAudioPlayer_bool = true;
    } else if (padName == "C#") {
      audioPath = "foundations/c#.mp3"; // Caminho do áudio para o pad C#
      cSustenidoAudioPlayer_bool = true;
    } else if (padName == "D") {
      audioPath = "foundations/d.mp3"; // Caminho do áudio para o pad D
      dAudioPlayer_bool = true;
    } else if (padName == "D#") {
      audioPath = "foundations/d#.mp3"; // Caminho do áudio para o pad D#
      dSustenidoAudioPlayer_bool = true;
    } else if (padName == "E") {
      audioPath = "foundations/e.mp3"; // Caminho do áudio para o pad E
      eAudioPlayer_bool = true;
    } else if (padName == "F") {
      audioPath = "foundations/f.mp3"; // Caminho do áudio para o pad F
      fAudioPlayer_bool = true;
    } else if (padName == "F#") {
      audioPath = "foundations/f#.mp3"; // Caminho do áudio para o pad F#
      fSustenidoAudioPlayer_bool = true;
    } else if (padName == "G") {
      audioPath = "foundations/g.mp3"; // Caminho do áudio para o pad G
      gAudioPlayer_bool = true;
    } else if (padName == "G#") {
      audioPath = "foundations/g#.mp3"; // Caminho do áudio para o pad G#
      gSustenidoAudioPlayer_bool = true;
    } else if (padName == "A") {
      audioPath = "foundations/a.mp3"; // Caminho do áudio para o pad A
      aAudioPlayer_bool = true;
    } else if (padName == "A#") {
      audioPath = "foundations/a#.mp3"; // Caminho do áudio para o pad A#
      aSustenidoAudioPlayer_bool = true;
    } else if (padName == "B") {
      audioPath = "foundations/b.mp3"; // Caminho do áudio para o pad B
      bAudioPlayer_bool = true;
    }

    // Toca o novo pad com o áudio correspondente

    _playNewPad(newAudioPlayer, audioPath);

    setState(() {
      isTransitioning = false; // Libera o bloqueio após a transição
    });
  }

  void _stop2() {
    // Verificação das notas naturais e seus booleans

    _fadeOutCurrentPad(cAudioPlayer);
    cAudioPlayer_bool = false;

    _fadeOutCurrentPad(cSustenidoAudioPlayer);
    cSustenidoAudioPlayer_bool = false;

    _fadeOutCurrentPad(dAudioPlayer);
    _fadeOutCurrentPad(dSustenidoAudioPlayer);
    _fadeOutCurrentPad(eAudioPlayer);
    _fadeOutCurrentPad(fSustenidoAudioPlayer);
    _fadeOutCurrentPad(fAudioPlayer);
    _fadeOutCurrentPad(gAudioPlayer);
    _fadeOutCurrentPad(gSustenidoAudioPlayer);
    _fadeOutCurrentPad(aAudioPlayer);
    _fadeOutCurrentPad(aSustenidoAudioPlayer);
    _fadeOutCurrentPad(bAudioPlayer);
    dAudioPlayer_bool = false;

    dSustenidoAudioPlayer_bool = false;

    eAudioPlayer_bool = false;

    fAudioPlayer_bool = false;

    fSustenidoAudioPlayer_bool = false;

    gAudioPlayer_bool = false;

    gSustenidoAudioPlayer_bool = false;

    aAudioPlayer_bool = false;

    aSustenidoAudioPlayer_bool = false;

    bAudioPlayer_bool = false;
  }

  void stop() {
    if (isTransitioning) {
      // Ignorar o clique durante a transição
      print("Transição em andamento, ação ignorada.");
      return;
    }

    setState(() {
      isTransitioning = true; // Bloqueia outras ações
    });
    String audioPath = "";

    // Verifica qual pad está tocando e para o áudio
    if (cAudioPlayer_bool) {
      _fadeOutCurrentPad(cAudioPlayer);
      cAudioPlayer_bool = false;
    }
    if (cSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(cSustenidoAudioPlayer);
      cSustenidoAudioPlayer_bool = false;
    }
    if (dAudioPlayer_bool) {
      _fadeOutCurrentPad(dAudioPlayer);
      dAudioPlayer_bool = false;
    }
    if (dSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(dSustenidoAudioPlayer);
      dSustenidoAudioPlayer_bool = false;
    }
    if (eAudioPlayer_bool) {
      _fadeOutCurrentPad(eAudioPlayer);
      eAudioPlayer_bool = false;
    }
    if (fAudioPlayer_bool) {
      _fadeOutCurrentPad(fAudioPlayer);
      fAudioPlayer_bool = false;
    }
    if (fSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(fSustenidoAudioPlayer);
      fSustenidoAudioPlayer_bool = false;
    }
    if (gAudioPlayer_bool) {
      _fadeOutCurrentPad(gAudioPlayer);
      gAudioPlayer_bool = false;
    }
    if (gSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(gSustenidoAudioPlayer);
      gSustenidoAudioPlayer_bool = false;
    }
    if (aAudioPlayer_bool) {
      _fadeOutCurrentPad(aAudioPlayer);
      aAudioPlayer_bool = false;
    }
    if (aSustenidoAudioPlayer_bool) {
      _fadeOutCurrentPad(aSustenidoAudioPlayer);
      aSustenidoAudioPlayer_bool = false;
    }
    if (bAudioPlayer_bool) {
      _fadeOutCurrentPad(bAudioPlayer);
      bAudioPlayer_bool = false;
    }

    // Toca o novo pad com o áudio correspondente

    setState(() {
      isTransitioning = false; // Libera o bloqueio após a transição
    });
  }

  // Função para verificar se qualquer player está ativo
  bool _isAnyPlayerActive() {
    return cAudioPlayer_bool ||
        dAudioPlayer_bool ||
        eAudioPlayer_bool ||
        fAudioPlayer_bool ||
        gAudioPlayer_bool ||
        aAudioPlayer_bool ||
        bAudioPlayer_bool ||
        cSustenidoAudioPlayer_bool ||
        dSustenidoAudioPlayer_bool ||
        fSustenidoAudioPlayer_bool ||
        gSustenidoAudioPlayer_bool ||
        aSustenidoAudioPlayer_bool;
  }

  // Função para exibir o LED piscando
  // Função para exibir o LED piscando
  // Construção do LED
  Widget _buildLed() {
    return AnimatedOpacity(
      opacity: _ledState ? 1.0 : 1, // Alterna opacidade entre 1.0 e 0.9
      duration: Duration(
          milliseconds: 500), // Duração de 500ms para suavizar o efeito
      curve: Curves.easeInOut,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _ledState
              ? Colors.red
              : Colors.black, // LED vermelho quando ativo
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _toggleLed(); // Verificar se algum player está tocando para ativar o LED
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLed(),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  // Slider de controle de volume

                  // Botões de aumentar e diminuir volume
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => {
                  _showInfoDialog(context),
                },
                child: Container(
                  child: Image.asset('assets/logo.png'),
                  margin: EdgeInsets.only(bottom: 24),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "C",
                          style: TextStyle(
                            fontSize: 28,
                            color: cAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: cAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (cAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("C",
                            cAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "C#",
                          style: TextStyle(
                            fontSize: 28,
                            color: cSustenidoAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            cSustenidoAudioPlayer_bool == true
                                                ? Colors.red
                                                : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (cSustenidoAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("C#",
                            cSustenidoAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "D",
                          style: TextStyle(
                            fontSize: 28,
                            color: dAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: dAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (dAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("D",
                            dAudioPlayer); // dAudioPlayer é o player associado ao pad D
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "Eb",
                          style: TextStyle(
                            fontSize: 28,
                            color: dSustenidoAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            dSustenidoAudioPlayer_bool == true
                                                ? Colors.red
                                                : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (dSustenidoAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("D#",
                            dSustenidoAudioPlayer); // dAudioPlayer é o player associado ao pad D
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "E",
                          style: TextStyle(
                            fontSize: 28,
                            color: eAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: eAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (eAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("E",
                            eAudioPlayer); // dAudioPlayer é o player associado ao pad D
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "F",
                          style: TextStyle(
                            fontSize: 28,
                            color: fAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: fAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (fAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("F",
                            fAudioPlayer); // dAudioPlayer é o player associado ao pad D
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "Gb",
                          style: TextStyle(
                            fontSize: 28,
                            color: fSustenidoAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            fSustenidoAudioPlayer_bool == true
                                                ? Colors.red
                                                : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (fSustenidoAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("F#",
                            fSustenidoAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "G",
                          style: TextStyle(
                            fontSize: 28,
                            color: gAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: gAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (gAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("G",
                            gAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "Ab",
                          style: TextStyle(
                            fontSize: 28,
                            color: gSustenidoAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            gSustenidoAudioPlayer_bool == true
                                                ? Colors.red
                                                : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (gSustenidoAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("G#",
                            gSustenidoAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "A",
                          style: TextStyle(
                            fontSize: 28,
                            color: aAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: aAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (aAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("A",
                            aAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "Bb",
                          style: TextStyle(
                            fontSize: 28,
                            color: aSustenidoAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            aSustenidoAudioPlayer_bool == true
                                                ? Colors.red
                                                : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (aSustenidoAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("A#",
                            aSustenidoAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                    ElevatedButton(
                      child: Center(
                        child: Text(
                          "B",
                          style: TextStyle(
                            fontSize: 28,
                            color: bAudioPlayer_bool == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90, 90)),

                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: bAudioPlayer_bool == true
                                            ? Colors.red
                                            : Colors.white))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (bAudioPlayer_bool == true) {
                              return Colors.transparent;
                            } else {
                              // Return another color if the condition is false
                              return Colors
                                  .transparent; // Or any other color you prefer
                            }
                          },
                        ),
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove overlay color
                        // Add other properties as needed
                      ),
                      onPressed: () {
                        _togglePad("B",
                            bAudioPlayer); // cAudioPlayer é o player associado ao pad C
                      },
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red, // Cor da parte ativa do slider
                  inactiveTrackColor:
                      Colors.red.withOpacity(0.5), // Cor da parte inativa
                  trackShape:
                      RectangularSliderTrackShape(), // Forma retangular da trilha
                  trackHeight: 16.0, // Altura do retângulo
                  thumbColor: Colors.transparent, // Cor do "pino"
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 10.0,
                      disabledThumbRadius: 0.21), // Tamanho do "pino"
                  overlayColor:
                      Colors.red.withOpacity(0.0), // Cor do overlay ao arrastar
                ),
                child: Slider(
                  value: currentVolume,
                  min: 0.0,
                  max: 1.0,
                  label: (currentVolume * 100).toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _adjustVolume(value);
                    });
                  },
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(80, 50)),

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (bAudioPlayer_bool == true) {
                          return Colors.transparent;
                        } else {
                          // Return another color if the condition is false
                          return Colors
                              .transparent; // Or any other color you prefer
                        }
                      },
                    ),
                    elevation:
                        MaterialStateProperty.all(0), // Set elevation to 0
                    overlayColor: MaterialStateProperty.all(
                        Colors.transparent), // Remove overlay color
                    // Add other properties as needed
                  ),
                  onPressed: () => {
                        _stop2(),
                        stop(),
                      },
                  child: Text(
                    "Stop",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Informações',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Desenvolvedor: Marcos Rodrigues',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Website: https://www.seusite.com',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Versão: 1.0.0',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Este é um aplicativo para [descrição do propósito do app].',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Fechar',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o dialog
            },
          ),
        ],
      );
    },
  );
}
