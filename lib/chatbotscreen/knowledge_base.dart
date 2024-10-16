import 'package:cloud_firestore/cloud_firestore.dart';

class KnowledgeBase {
  late List<String> javaKeywords;
  late List<String> nonJavaKeywords;

  KnowledgeBase() {
    javaKeywords = ["Java", "JDK", "JRE", "JVM", "Java class", "Java method", "Java object",
      "Java variable", "Java array", "Java loop", "Java function","function", "Java package",
      "functions","exceptions","exception","abstraction","abstractions","IDE","generics",
      "annotation","annotations","lambda","lambdas","API","Stream API","Stream",
      "concurrency","synchronization","synchronizations","database","databases","Gradle","Gradles",
      "memory management","JUnit",
      "Java exception", "Java interface", "Java inheritance", "Java polymorphism",
      "Java encapsulation", "Java abstraction", "Java multithreading", "Java IDE",
      "Eclipse", "IntelliJ", "NetBeans", "BlueJ", "JavaFX", "Swing", "AWT",
      "Java collections", "Java generics", "Java annotations", "Java lambda",
      "Java Stream API", "Java concurrency", "Java synchronization", "Java database",
      "JDBC", "Java networking", "Java sockets", "Java servlets", "Java JSP",
      "Java Spring", "Java Hibernate", "Java Maven", "Java Gradle", "Java JUnit",
      "Java logging", "Java debugging", "Java performance", "Java memory management",
      "for loops","String Concatenation", "Inheritance","Public class", "Syntax",
      "enum Level", "public static void main", "Scanner", "java.util", "nextLine()", "import java.util.Scanner", "class Main",
      "public static void main(String[] args)", "nextBoolean()", "nextByte()", "nextDouble()", "nextFloat()", "nextInt()", "nextLine()",
      "nextLong()", "nextShort()", "import java.util.Scanner", "java.time", "LocalDate", "LocalTime", "LocalDateTime", "DateTimeFormatter",
      "java.time.LocalDate", "now()", "import java.time.LocalDate", " LocalDate myObj = LocalDate.now()", " System.out.println(myObj)",
      "java.time.LocalTime", "DateTimeFormatter", "ofPattern()", "ArrayList",
      "java.util", "ArrayList<String>", "get()", "set()", "remove()", "clear()", "size", "for", "Integer", "Boolean",
      "Arrays Class", "Arrays Methods", "Output Methods", "System.out", "Math Methods", "String Methods", "Reserved Keywords",
      "Reference Documentation",  "compare()", "copyOf()", "deepEquals()","equals()", "fill()", "mismatch()","sort()", "length",
      "print()", "printf()", "println()",
      "absolute value", "arccosine ", "addExact", "arcsine ", "arctangent", "angle theta", "cube root", "ceil", "copySign","cosine ",
      "hyperbolic cosine", "decrementExact", "exp", "expm1", "floor",  "floorDiv", "floorMod", "unbiased exponent","intermediate overflow or underflow",
      "hypot", "IEEE", "incrementExact", "natural logarithm", "base 10 logarithm", "natural logarithm (base E)", "max", "min",
      "multiplyExact", "negateExact", "nextAfter", "nextDown", "nextUp", "power ",  "random number", "rint", "rounded ", "scaln",
      "signum", "sine ", "hyperbolic sine", "square root", "subtractExact", "tangent", "hyperbolic tangent", "toDegrees", "toIntExact",
      "radians", "ulp",
      "charAt", "Unicode", "codePointAt", "codePointBefore", "codePointCount", "comparedTo", "lexicographically", "compareToIgnoreCase",
      "concat", "contains", "CharSequence", "StringBuffer", "contentEquals", "copyValueOf", "ends with", "equal", "equalsIgnoreCase",
      "format string", "array of bytes", "hash code", "first found occurrence", "canonical representation", "intern", "Joins", "lastIndexOf", "match",
      "codePointOffset", "offset", "regions", "replace", "replaceAll", "replaceFirst",  "ofPattern()", "Split", "starts with", "subsequence",
      "substring", "toCharArray", "lower case", "toString", "upper case", "Removes whitespace", "trim", "representation",
      "abstract", "debugging", "assert", "Break", "boolean", "-128 and 127","byte", "Marks a block of code", "switch", "Catch",
      "single character", "class", "Continue", "Not in use", "final", "const", "default", "do", "double", "conditional statements", "else",
      "enumerated", "enum", "unchangeable", "Export", "Extend", "finally", "float", "for", "goto", "if", "implements", "import","instance  of",
      "Add Two Numbers", "Count Number of Words in a String", "Reverse a String", "Sum of an Array", "Area of Rectangle","Odd Number",
      "Even Number",
      "File Handling", "Create a File", "Read a File", "Delete a File",
      "Main","String","Strings","Concatenate","Concatenation","args","arg","System.out.println","println","System out println","Systemoutprintln","Hello World","Hello Worlds","public static void",
      "static void","void","static","Oracle","programming","programmings","programming languages","programming language","code","codes","develop","Syntax","Syntaxes","public static void main(String[] args)",
      "System.out.println()","Output","Print","Text","println()","Double Quotes","Method","Methods","Print Number","Print Text","Number","program","example","Comments","Comment",
      "Single-line","Single-lines","line","new line","lines","new lines","Variables","Variable","containers","container","storing","store","data","datas","value","values","type","types","String","Strings","int",
      "integer","integers","float","floats","number","numbers","decimals","decimal","char","character","boolean","bool","booleans","bools","Declaring","Declarings","Declared",
      "Creating","create","num","final","finals","Final Variables","Print Variables","Declare Multiple Variables","Identifiers","Identifier","name","names","Reserved words",
      "byte","bytes","short","double","Data Types","Data Type","Primitive data types","Primitive data type","Non-primitive data types","Non-primitive data type",
      "Arrays","array","whole","fractional","fractionals","true","false","single","characters","ASCII","letter","letters","long","numeric","reference types","reference",
      "null","Interface","Interfaces","Type Casting","Widening Casting","Narrowing Casting","Operator","Operato","Arithmetic","Arithmetics","Assignment","Assignments",
      "addition assignment","Comparison Operators","Comparison","Logical Operators","Logical","length()","String Length","indexOf()","indexOf","Length",
      "concat()","concat","backslash escape character","backslash escape","Carriage Return","Tab","Backspace","Form Feed","Java Math","Math.max(x,y)","Math.max","Math.min(x,y)",
      "Math.min","Math.sqrt(x)","Math.sqrt","min","max","sqrt","Math.abs(x)","constructors","Garbage collection","Expression","Expressions",
      "Conditions","Condition","Statements","Statement","Short Hand","ternary","Switch","default","defaults","break","breaks","block","Do/While","Do While","Do","While",
      "Nested","For each","For-each","Elements","Element","Length","Multidimensional","Method","methods",
      "Parameters","Parameter","Arguments","Argument","Multiple","return","returns","Overloading","Scope","Block Scope","Block","Recursion","Recursions",
      "Halting Condition","Halting",
      "Abstraction", "Inheritance", "Inheritances","Abstractions", "Polymorphism", "Polymorphisms","Encapsulation", "Encapsulations", "Object oriented programming",
      "Object oriented", "program", "Collections","Collection", "Association", "Associations","Composition", "Compositions", "Exception handling",
      "Exception handlings", "handling", "Garbage collections","JDBC", "Multithreading", "Multithreadings","Overloading", "Fundamentals", "Fundamental",
      "Aggregation", "Aggregations", "Constructor","Constructors", "Packages", "Package","Field", "Fields", "Executing","Execute","Execution",
      "OOP","Java Classes","Object-oriented programming","Object-oriented programmings","Class","Object","Classes","Objects","Classes and Objects",
      "Class Attributes","Class Attribute","Class Methods","Class Method","static method","static methods","public method","public methods", "Java Constructors","Java Constructor",
      "Constructor","Constructor Parameters","Constructor Parameter","Java Modifiers","Java Modifier","Modifiers","Modifiers","public keyword"," access modifier","Non-Access Modifiers",
      "access modifiers","Non-Access Modifier","public access modifier","default access modifier","protected access modifier","private access modifier",
      "final Non-Access Modifiers","abstract Non-Access Modifiers","transient Non-Access Modifiers","synchronized Non-Access Modifiers","volatile Non-Access Modifiers",
      "Final","static method","abstract method ","Encapsulation","get method","set method","Java Packages"," Java API","User-defined Packages","API",
      "Import a Class","import java.util.Scanner;","import java.util.Scanner","java.util","javautil","user input","Scanner class","Scanner","nextLine() method",
      "nextLine()","import java.util.*","java.util.*","java.util.Scanner","import java.util.*;","Java Inheritance","Inheritance","subclass","superclass","extends",
      "Polymorphism","Java Inner Classes","Java Inner Class","Inner Classes"];

    nonJavaKeywords = [
      "Python", "C++", "Ruby", "PHP", "JavaScript",
      "C#", "Swift", "Kotlin", "Scala",
      "Go", "Rust", "Perl", "Haskell", "Clojure",
      "Erlang", "Groovy", "Bash", "PowerShell",
      "Lua", "Dart", "TypeScript", "Objective-C", "Assembly",
      "SQL", "MATLAB", "Visual Basic", "Delphi", "Fortran",
      "Lisp", "Prolog", "Scratch", "Solidity", "Elixir"
    ];

    getFirestoreKeywords().then((firestoreKeywords) {
      javaKeywords.addAll(firestoreKeywords);
    });
  }



  Future<List<String>> getFirestoreKeywords() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('keywords')
        .doc('java')
        .get();
    final data = querySnapshot.data();

    if (data != null && data.containsKey('keywords')) {
      final firestoreKeywords = List<String>.from(data['keywords']);
      return firestoreKeywords;
    } else {
      return [];
    }
  }


}