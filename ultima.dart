import 'dart:io';//para leer la entrada del usuario desde la consola
import 'dart:math';//se utiliza para calcular el máximo en el algoritmo de Boyer-Moore

class User {//usuario del sistema de búsqueda
  String username;//nombre de usuario
  String password;//contra
  List<SearchEntry> searchHistory;//historial de busqueda
//constructor de clase
  User(this.username, this.password) : searchHistory = [];//se inicializan username,contra. y searchHistory como una lista vacía.
}

class SearchEntry {//para entrar al historial de busqueda
  TextData text;//datos de texto
  String algorithm;//algoritmo utilizado
  String searchQuery;//consulta de busqueda
  double searchDuration;//duracion de busqueda
  int occurrences;//cant palabras encontradas

  SearchEntry(this.text, this.algorithm, this.searchQuery, this.searchDuration, this.occurrences);//constructor inicializa propiedades
}

class TextData {//datos de texto
  String title;//titulo de texto
  String content;//contenido de texto

  TextData(this.title, this.content);//inicializacion rapida para asignar valores a las propiedades
}

class StringSearch {//implementacion de algoritmos de busqueda de cadena

//Boyer-Moore es una técnica de búsqueda de patrones eficiente.
  List<int> boyerMoore(String str, String pat) {//Recibe dos cadenas de texto
    str = str.toLowerCase();//str (el texto en el que se realizará la búsqueda)
    pat = pat.toLowerCase();//pat (el patrón que se busca en el texto).
    ////arriba -primero convierte las cadenas de texto a minúsculas
    ///
//se inicializan variables 
    int m = pat.length;//m longitud de patron
    int n = str.length;//n longitud de texto
    int i = 0;//indice

// lista badchar-almacena información sobre los caracteres que no coinciden en el patrón.
//para determinar los desplazamientos en la búsqueda y saltar posiciones innecesarias.
    List<int> badchar = List<int>.filled(65536, -1); // Increase the size of the array
   //rango de valores unicode el valor Unicode se utiliza para acceder a los puntos de código Unicode de los caracteres individuales en las cadenas de texto
   
   // método badCharHeuristic() para 
   //  calcular información sobre los caracteres que no coinciden en el patrón
    badCharHeuristic(pat, m, badchar);//actualizará la lista badchar con los índices apropiados.

    int s = 0;// variable s se utiliza como un índice para desplazarse a través del texto.
  //La lista arr se utiliza para almacenar las posiciones de las ocurrencias del patrón en el texto.
    List<int> arr = [];

//se realiza una comparación de patrones en sentido inverso
    while (s <= n - m) {
      int j = m - 1;

      while (j >= 0 && pat.codeUnitAt(j) == str.codeUnitAt(s + j)) { // Use codeUnitAt to get the Unicode code point
        j--;
      }

      if (j < 0) {
        arr.add(s);//si se encuentra una coincidencia completa, se agrega la posición de inicio de la coincidencia a la lista arr
        s += (s + m < n) ? m - badchar[str.codeUnitAt(s + m)] : 1;
      } else {
        //Si no hay coincidencia, se calcula un desplazamiento basado en la información almacenada en badchar 
        //para saltar posiciones innecesarias en la búsqueda.
        s += max(1, j - badchar[str.codeUnitAt(s + j)]);
      }
    }
    //devuelve la lista arr que contiene las posiciones de todas las 
    //ocurrencias del patrón en el texto.
    return arr;
  }

  void badCharHeuristic(String str, int size, List<int> badchar) {
    for (int i = 0; i < 65536; i++) {
      badchar[i] = -1;
    }

    for (int i = 0; i < size; i++) {
      badchar[str.codeUnitAt(i)] = i;
    }
  }

//Algoritmo de Knuth-Morris-Pratt (KMP)
//algoritmo eficiente para buscar patrones en una cadena de texto.

  List<int> morrisPratt(String str, String pat) {//recibe las cadenas str (texto de búsqueda) y pat (el patrón que se busca en el texto).
    //se convierten las cadenas de texto a minúsculas y se inicializan variables. 
    str = str.toLowerCase();
    pat = pat.toLowerCase();

    List<int> retVal = [];
    int M = pat.length;
    int N = str.length;
    int i = 0;
    int j = 0;

    //se crea una lista llamada lps-almacenar información sobre los prefijos y sufijos más largos en el patrón
    List<int> lps = List<int>.filled(M, 0);
//El método computeLPSArray() se utiliza para calcular esta información.
    computeLPSArray(pat, M, lps);
//buc;e que recorre el texto y patron en simultaneo,comparando 
    while (i < N) {
      if (pat[j] == str[i]) {//Si se encuentra una coincidencia parcial, los índices se incrementan. 
        j++;
        i++;
      }

      if (j == M) {//Si se encuentra una coincidencia completa, se agrega la posición de inicio de la coincidencia a la lista retVal
        retVal.add(i - j);
        j = lps[j - 1];
      } else if (i < N && pat[j] != str[i]) {//Si no hay coincidencia, se realiza un desplazamiento en el patrón utilizando la información almacenada en lps
        if (j != 0) {
          j = lps[j - 1];
        } else {
          i = i + 1;
        }
      }
    }
//devuelve la lista retVal que contiene las posiciones de todas las ocurrencias del patrón en el texto.
    return retVal;
  }

  void computeLPSArray(String pat, int m, List<int> lps) {
    int len = 0;
    int i = 1;

    lps[0] = 0;

    while (i < m) {
      if (pat[i] == pat[len]) {
        len++;
        lps[i] = len;
        i++;
      } else {
        if (len != 0) {
          len = lps[len - 1];
        } else {
          lps[i] = 0;
          i++;
        }
      }
    }
  }

//Algoritmo de Fuerza Bruta:
//método de búsqueda simple y directo que compara todas las subcadenas de un texto con un patrón
  List<int> bruteForce(String pattern, String subject) {
    //Recibe dos cadenas de texto: pattern (el patrón que se busca) 
    //y subject (el texto en el que se realizará la búsqueda).
    //convierte las cadenas de texto a minúsculas.
    pattern = pattern.toLowerCase();
    subject = subject.toLowerCase();

// lista llamada matches para almacenar las posiciones de las coincidencias encontradas
    List<int> matches = [];
    // inicializa variables
    int n = subject.length;
    int m = pattern.length;

//bucle  recorre todas las subcadenas del texto en busca de coincidencias con el patrón.
    for (int i = 0; i <= n - m; i++) {
      bool found = true;
      for (int j = 0; j < m; j++) {   //cada subcadena, se compara cada carácter con el patrón
        if (subject[i + j] != pattern[j]) {
          found = false;
          break;
        }
      }

      if (found) {////Si hay una coincidencia completa
        matches.add(i);//se agrega la posición de inicio de la coincidencia a la lista matches.

      }
    }
//devuelve la lista matches que contiene las posiciones de todas las 
//ocurrencias del patrón en el texto.
    return matches;
  }
}

void main() {
  //2 listas
  List<User> users = [//users-listas de usuarios
    User('Erika', '123'),
    User('Amy', '456'),
  ];

  List<TextData> registeredTexts = [];//registeredTexts (lista de textos registrados)

//se llama a la funcion login para que el usuario inicie sesion
//aqui se esta suponiendo que van a ingresar el usuario y contra correctos
  User loginUser = login(users);
  if (loginUser != null) {//si el inicio de sesion es exitoso llama a la funcion showmenu
    showMenu(loginUser, registeredTexts);
  } else {
    print('Credenciales incorrectas. Saliendo del programa.');
  }
}

User login(List<User> users) {//funcion login
  print('Ingrese su nombre de usuario: ');//solicita usuario
  String? username = stdin.readLineSync();
  print('Ingrese su contraseña: ');//y contra
  String? password = stdin.readLineSync();
//busca en la lista de usuarios para verificar si las credenciales coinciden
  for (User user in users) {
    if (user.username == username && user.password == password) {
      return user;//si es que hay coincidencia se devuelve el objeto user
    }
  }

  return User('', '');//si no hay coincidencia devuelve el User vacio
}

//funcion show menu
void showMenu(User user, List<TextData> registeredTexts) {
  print('¡Bienvenido, ${user.username}!');
  int option;

  do {
    print('Menú de opciones:');
    print('1. Registrar un texto');
    print('2. Buscar palabra / oración en un texto');
    print('3. Ver historial de búsquedas');
    print('0. Salir');

    option = int.parse(stdin.readLineSync() ?? '0');

    switch (option) {
      case 1:
        registerText(registeredTexts);
        break;
      case 2:
        searchText(user, registeredTexts);
        break;
      case 3:
        showSearchHistory(user);
        break;
      case 0:
        print('¡Hasta luego, ${user.username}!');
        break;
      default:
        print('Opción inválida. Intente nuevamente.');
    }
  } while (option != 0);
}
//permite al usuario registrar un nuevo texto en el sistema
void registerText(List<TextData> registeredTexts) {
  print('Ingrese el título del texto: ');
  String? title = stdin.readLineSync();
  print('Ingrese la ruta del archivo de texto: ');
  String? filePath = stdin.readLineSync();

  try {
    File file = File(filePath!);
    String content = file.readAsStringSync();
//Si la lectura del archivo tiene éxito, crea una instancia de TextData
    TextData textData = TextData(title ?? '', content);
    registeredTexts.add(textData);//agrega el objeto textData a la lista registeredTexts que almacena todos los textos registrados.

    print('Texto registrado exitosamente: $title');
  } catch (e) {
    print('Error al leer el archivo: $e');
  }
}
//que palabra quieres buscar 
void searchText(User user, List<TextData> registeredTexts) {
  if (registeredTexts.isEmpty) {//verifica si hay textos
    print('No se han registrado textos en el sistema.');
    return;
  }

  print('Seleccione un texto:');
  for (int i = 0; i < registeredTexts.length; i++) {
    print('${i + 1}. ${registeredTexts[i].title}');
  }
//El usuario elige un índice de texto válido y se almacena en textIndex.
  int textIndex = int.parse(stdin.readLineSync() ?? '0') - 1;//si la entrada es nula se pone valor 0

  if (textIndex < 0 || textIndex >= registeredTexts.length) {
    print('Índice de texto inválido.');
    return;
  }

  TextData selectedText = registeredTexts[textIndex];
//usuario elige algoritmo
  print('Seleccione un algoritmo de búsqueda:');
  print('1. Boyer-Moore');
  print('2. Knuth-Morris-Pratt');
  print('3. Fuerza Bruta');

  int algorithmOption = int.parse(stdin.readLineSync() ?? '0');

  if (algorithmOption < 1 || algorithmOption > 3) {
    print('Opción inválida.');
    return;
  }
//ingrese palabra
  print('Ingrese la palabra/oración a buscar:');
  String? searchQuery = stdin.readLineSync();

//Se crea una instancia de la clase StringSearch para realizar la búsqueda.
  StringSearch search = StringSearch();
  List<int> searchResults;
  int totalOccurrences = 0;
  double searchDuration;

  switch (algorithmOption) {
    case 1:
      searchResults = search.boyerMoore(selectedText.content, searchQuery ?? '');
      break;
    case 2:
      searchResults = search.morrisPratt(selectedText.content, searchQuery ?? '');
      break;
    case 3:
      searchResults = search.bruteForce(searchQuery ?? '', selectedText.content);
      break;
    default:
      print('Opción inválida.');
      return;
  }

  totalOccurrences = searchResults.length;//los resultados de busqueda se almacenan en searchresults
//Se utiliza un objeto Stopwatch para medir el tiempo de duración de la búsqueda.
  final stopwatch = Stopwatch();
  stopwatch.start();

  // Realiza la búsqueda

  stopwatch.stop();
  searchDuration = stopwatch.elapsedMicroseconds / 1000; // Calcula el tiempo en milisegundos con decimales
//menu de opciones
  print('Opciones:');
  print('1. Mostrar cantidad de apariciones');
  print('2. Ver apariciones');

//lee la opción seleccionada por el usuario desde la entrada estándar 
//y la almacena en la variable resultOption
  int resultOption = int.parse(stdin.readLineSync() ?? '0');

  switch (resultOption) {
    case 1:
      print('Tiempo de duración de la búsqueda: ${searchDuration.toStringAsFixed(3)} milisegundos');
      print('Cantidad de apariciones: $totalOccurrences');
      break;
    case 2:
      if (searchResults.isEmpty) {
        print('La palabra/oración no se encontró en el texto.');
        return;
      }
//Se inicializa la variable currentIndex en 0.
//variable se utiliza para realizar un seguimiento de la aparición actual 
//que se está mostrando al usuario
      int currentIndex = 0;
//bucle while (true) crea un bucle infinito para permitir que 
//el usuario navegue por las apariciones.
      while (true) {
      //imprimen información sobre la aparición actual que se está mostrando al usuario. 
        print('Aparición ${currentIndex + 1} de ${searchResults.length}:');
        print('Texto: ${selectedText.title}');
        print('Índice de inicio: ${searchResults[currentIndex]}');
        print('Sección del texto: ${selectedText.content.substring(searchResults[currentIndex])}');//sección de texto que coincide con la aparición 

        print('Opciones:');
        print('1. Ocurrencia siguiente');
        print('2. Ocurrencia anterior');
        print('3. Cancelar');
// La opción seleccionada se almacena en la variable option.
        int option = int.parse(stdin.readLineSync() ?? '0');

        switch (option) {
          case 1://opción 1, se incrementa currentIndex en 1 para mostrar la siguiente aparición
            currentIndex++;// Si currentIndex alcanza el límite del número de apariciones 
            if (currentIndex >= searchResults.length) {
              currentIndex = 0;//se vuelve a establecer en 0 para mostrar la primera aparición.
            }
            break;
          case 2://opción 2, currentIndex se decrementa en 1 para mostrar la aparición anterior
            currentIndex--;
            if (currentIndex < 0) {//Si currentIndex es menor que 0,
              currentIndex = searchResults.length - 1;//  se establece en el índice de la última aparición
            }
            break;
          case 3:// opción 3, se sale del bucle y regresa al menú principal.
            return;
          default:
            print('Opción inválida. Intente nuevamente.');
        }
      }
      break;
    //Si el usuario selecciona una opción inválida, se muestra un mensaje de error.
    default:
      print('Opción inválida.');
  }
//agrega una nueva entrada de búsqueda a la propiedad searchHistory del objeto user
  user.searchHistory.add(SearchEntry(selectedText, algorithmOption.toString(), searchQuery ?? '', searchDuration, totalOccurrences));
}
//muestra historial de usuario
void showSearchHistory(User user) {
  if (user.searchHistory.isEmpty) {
    print('No hay historial de búsquedas.');//verifica si historial esta vacio
    return;
  }
//muestra cada entrada del historial
  print('Historial de búsquedas:');
  for (int i = 0; i < user.searchHistory.length; i++) {
    SearchEntry entry = user.searchHistory[i];
    print('${i + 1}.');
    print('Texto: ${entry.text.title}');
    print('Algoritmo: ${getAlgorithmName(entry.algorithm)}');
    print('Palabra/oración: ${entry.searchQuery}');
    print('Tiempo de duración de la búsqueda: ${entry.searchDuration.toStringAsFixed(3)} milisegundos');
    print('Cantidad de apariciones: ${entry.occurrences}');
    print('---------------------');
  }
}

//recibe una opción de algoritmo como una cadena y 
//devuelve el nombre legible del algoritmo correspondiente.
String getAlgorithmName(String algorithmOption) {
  switch (algorithmOption) {
    case '1':
      return 'Boyer-Moore';
    case '2':
      return 'Knuth-Morris-Pratt';
    case '3':
      return 'Fuerza Bruta';
    default:
      return 'Desconocido';
  }
}
