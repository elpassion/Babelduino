# Babelduino

Arduino library that allows writing code in local language. Syntax colouring
included! 🎨

```c
void loop() {
  auto distance = radar.ping_cm();
  
  if (distance < 15) {
    go_forward(250);
  } else {
    turn_right(250);
    go_forward(100);
  }
}
```
⬇🇵🇱
```c
procedura powtarzaj() {
  niech odleglosc = radar.ping_cm();
  
  jezeli (odleglosc < 15) {
    do_przodu(250);
  } w_przeciwnym_razie {
    obroc_w_prawo(250);
    do_przodu(100);
  }
}
```

## But... why? 😱

The aim is to make it easier for mentors **to show the joy of programming to 
young learners**, by eliminating spoken language barrier. It was inspired by 
platforms such as 
[Logo](https://en.wikipedia.org/wiki/Logo_(programming_language)) and 
[Scratch](https://scratch.mit.edu).

## Usage

Add the Library and include all translations:

```c
#include <Babelduino.h>
```

Or just the one that's interesting to you:

```c
#include <Babelduino_PL.h>
```

## Adding new languages and keywords

Feel free to add new language or keyword:

1. Take a look at [extras/mappings/pl.yml](extras/mappings/pl.yml) for an 
   example of keyword mapping (`if` -> `jezeli`).

2. You can create several different mappings for the same keyword.

2. Create your own mapping YAML file and put it into 
   [extras/mappings](extras/mappings) directory.

3. Run `extras/generate` script (Ruby needed).

   You must provide a path to original Arduino IDE `keywords.txt` file. For 
   macOS, it is located inside the app package:

   `$ ./extras/generate /Applications/Arduino.app/Contents/Java/lib/keywords.txt`
   
4. The script will generate C header files with keyword aliases and add 
   translations to [keywords.txt](keywords.txt) file.

5. Create a Pull Request with your new translations :)

## How does it work?

Under the hood, the library provides "aliases" for original keywords using 
`#define` directives, such as:

`#define jezeli if`

It also uses original keyword data from Arduino IDE's `keywords.txt` file, so 
the translations are formatted and coloured in the IDE the same way as the 
original keywords.

## Extra keywords

There is a possibility to add an "empty" translation, an additional keyword that
will be ignored by the compiler but highlighted by the IDE. It makes it easier 
to teach concepts like `function` vs `procedure`, where you may need more words 
to describe what the piece of code does:

```c
int sum(int a, int b) {
  return a + b;
}
```

```c
podaj liczbe suma(liczba a, liczba b) {
  wynik a + b;
}
```

Here, `podaj` (synonym for "returning" in Polish) is only a marker for a
function (something returning a value), and `liczbe` is an alias for `int` type.

If you want an extra keyword, simply add it to your YAML mapping, describing 
how it should be highlighted (here, `podaj` will be coloured in the same way as 
`auto` keyword):

```yaml
__extra__:
  auto: podaj
```
