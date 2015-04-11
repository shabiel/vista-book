# A Quick Introduction to MUMPS
## What is MUMPS?
MUMPS is a text processing language with an integrated database. The database
is integrated in the sense that you access the database directly from the
language itself. There is no intermediate driver to get to the database.

The acronym stands for Massachusetts General Hospital Utility Multi-Programming
System. The language was designed by Neil Pappalardo in 1966; and it was 
purposely designed to replace assembly language for medical use. Neil 
Pappalordo went on to start Meditech, still one of the largest electronic medical 
records software vendors.

The language was standardized by ANSI and ISO in 1977. Due to this, its
medical background, and its suitability for representing multifaceted medical data,
it remains a very common language in medical informatics. Much of how it ended up 
that way is due to various pioneers, notably Ted O'Neil,
who envisioned the application of computing to medicine.

MUMPS is the programming language behind Meditech, VISTA, RPMS (a cousin
of VISTA), and notably, the most successful EMR in the world, Epic. Cerner, the
other big EMR system used in the United States, does not use MUMPS.

MUMPS is often abbreviated as M.

MUMPS suffers from a bad rap because of its obtuse syntax (not really obtuse,
but rather not common in today's popular programming languages), limitations of
the the hardware in the late 1970s and early 1980s, and the obligation to write
all code in uppercase; a result of its history and background. The absence of
variable scoping, anonymous blocks to use with `for` and `if` commands, and the
ability to pass parameters (all of which were remedied in the 1990 M standard)
means that early code, much of which is still in operation, is rather
unreadable.

Today, properly written MUMPS code is very readable. That unfortunately will never
remove the history of how its early code used to look.

## Why MUMPS?
MUMPS is very common in medicine; and also used (to a lesser extent) in banking.
We will focus here on its history with medicine.

### Why the M integrated database?
In the 1960s and 1970s, there were essentially two
models of databases. Fixed record databases and sparsely stored databases. The
relational model matured around the beginning of the 80s, and by that time M was
well established. However, at that time relational databases suffered from the same
storage problem as fixed record databases, in which they actually stored everything.

Which brings us to medicine and how a sparse database storage mechanism really fits
medicine well. Medical observations cannot be easily recorded in a fixed record
system because of the massive amount of storage it would need. Medical observations
are not common between patients, and also happen to be of multiple dimensions. For
a simple example, a patient may have several "vitals" documented on them (e.g Heart
Rate [pulse], Respiration Rate), but these vitals are not taken on all patients.
Vitals also happen to have qualifiers associated with them, such as what position
a patient was in when the vital was taken. All of these factors, if implemented in
the well understood fixed record system, with or without any relational
simplification, would result in the need for a lot of storage in an era when storage was measured
in the 10s of megabytes. Using sparse storage was the way to go.

M, as designed by Neil Pappalardo, also had an integrated database in the language
itself. Global variables and file system data was only distinguished by the presence
of a caret (^) at the beginning of a variable. For example, `data` is a local variable, stored
in memory; `^data` is stored on disk. Storing data was very easy in M.

Add to the last two advantages the fact that the language was standardized, 
didn't belong to any vendor, and the language explicitly allowed multiple processes
to manipulate the same data, and you can see that choosing MUMPS for medicine is
basically a no-brainer.

## MUMPS today
As mentioned above, MUMPS is predominantly used in medical systems. However, as time
passed, the choices of MUMPS implementations have decreased, to the point that we
have 7 implementations left; with 2 having the highest market share.

The implementations are:

 * Intersystems Caché (aka OpenM)
 * Greystone Technology MUMPS (GT.M)
 * MV1
 * M21
 * MiniM
 * Kevin O'Kane's MDH

The most commonly used M implementations are Caché and GT.M. The main
two differences between Caché and GT.M are:

 # Caché does not implement transactions properly, whereas GT.M provides full
 ACID compliant transactions. GT.M was born in the banking sector, where ACID
 compliance is critical to business operations, as money transfers need to be
 exact. Caché does not provide that guarantee; and in any case, electronic
 medical records such as VISTA and Epic were not coded to use transactions.
 Manuals explicitly tell the users that in an interrupted session data will be
 lost; and indeed, frequently it is, from the experience of the author.

 # Caché has subsumed MUMPS into a language called Caché ObjectScript. This
 language add semantics to MUMPS that don't exist in standard MUMPS, like
 braces and flexible spacing everywhere.

In this section, it is worth mentioning the previous major M implementations: 
Digital Standard MUMPS, and Micronetics Standard MUMPS, abbreviated as DSM and MSM.
These were the major platforms on which M ran for VISTA and RPMS. Intersystems,
in an effort to consolidate the market, bought both DSM and MSM in the late
1990's. 

# The M Language
We will start our abbreviated discussion of the M language here. Please note that
rather than my striving to be completely accurate, I will strive to be useful. I
will show how M is written today rather than the various allowable permutations
and what the M ISO/ANSI 95 standard explicitly allows or does not allow.

## Hello World 
Let's look at a hello world example.

`helloworld.m`
```
helloworld ; hello world program
main
 write "hello ","world",! read "press enter to continue: ",x
 quit
```

## M language structure
It's best to start the M language overview by looking at the syntax.

M code looks like this:
```
 <command> <space> <argument> <space> <command> <space> <argument>
```

We immediately notice a couple of things: spaces matter, and there can be more
than one command on a single line without a demarkation character, very commonly a
semicolon (;) in most of today's common languages. A semicolon (used in the above
program) is actually the comment line initiator, like '//' in C style languages.

Arguments to a single command can be combined together by using a comma.
```
 <command> <space> <argument1>,<argument2>,<argument3> <space> <command>...
```
This is actually the format we see in our example.

One puzzling (but hard to notice) item is that "helloworld" and "main" are
flushed to the left, it is not a command, and every line under it contains
a space at the beginning.  These items are all significant.

### Line Labels
Any identifier flushed to the left is called a line label. Essentially, like in
other languages, it is a label which could be a goto target. Except in MUMPS, it is
both a procedure/function target and a goto command target. Thus you can write
`do main^helloworld` and `goto main^helloworld`. A line label can be followed by M
commands or a comment using a ';'.

### Level Line (really just the M code)
Any line with at least one space or at least one tab at the beginning of the
line is considered a code line. That space or tab can follow a label or
a formal list. That contains code to be executed. If the code is placed without
a space/tab at the front, the first word in the code will be considered a line
label, and the next argument won't be a command, and thus the interpreter will
complain about a syntax error.

### Formal Lines with a Formal List
In the M 1990 standard, M finally gained the ability to accept parameters to a
procedure or function. So rather then `main`, you can write `main(arg)`, and invoke
it with `do main^helloworld(1)`, where 1 is the arg. This line is known as a formal
line and the parameters are known as a formal list.

### Allowable formats for labels
Labels may begin with a % and a number of letters and numbers, a first letter
then any number of letters and numbers; or just a number with no following
letters. E.g.
```
%test ; okay
test  ; okay
test1 ; okay
1test ; invalid
1     ; okay
test% ; invalid
```
In the current Standards and Conventions (https://www.voa.va.gov/DocumentView.aspx?DocumentID=182), the maximum allowable length of a label is 8 characters that must be in
uppercase. GT.M and Cache allow a maximum lengh of 32 characters. There is no
syntax error if you exceed this, but any characters following the 32 will not
be used to distinguish between labels.

### The "Stack"
Since its first days, M implements a virtual (i.e. not implemented in the
processor) stack. This stack is incremented every time a procedure or
a function invocation takes place. Once the procedure or function is done, the
stack is decremented back again. 

### Example Program

// TODO: Make sure to run this and make sure it works.

All right. We need to tie all of these concepts together.
```
circumference ; calculate the circumference of a circle ; label line
 ; level line
 ;
 write "Sorry. No entry from the top is allowed.",! ; level line
 ;
main ; Main entry point
 read x,"type enter to begin: ",!
 write !!
 read "Enter a radius: ",rad,!
 write !!
 set circumference=$$calculate(rad)
 write "circumference is "_circumference,!
 quit
 ;
calculate(radius) ; formal line. Formal list contains one variable
 new circ
 set circ=2*3.14*radius ; 2 pi r
 quit circ
 ;
```

## M Language Expressions

//TODO: Find the definition in the M standard, and give a simple definition.

An expression is argument to commands that evaluate text rather than act on
other types. For example, in

```
write "hello world"
```

the expression is "hello world". Individual commands may accept arguments that
are not expressions (such as ! for the write command). Here are the important
expressions in MUMPS (two are omitted since they are never used in real
code).

Command | Result | Explanation
------- | ------ | -----------
`write 3*4 `| 12  | \* is multiply
`write 3/4 `| .75 | / is divide. Divisions in M return the decimals; they are not
truncated to the integer.
`write 3\4 `| 0 | Integer division
`write 11\4 `| 2 | Integer division
`write 6#4 `| 2 | Modulus (i.e. division remainder)
`write 2**4 `| 16 | ** is to the power of
`write 2+3 `| 5   | + is addition
`write 2-3 `| -1  | - is subtraction
`write 2_3 `| 23 |  _ is concatenation
`write "hello"_"world" `| helloworld | another concatenation
`write +"5^2" `| 5 | convert a string into a number
`write -"5^2" `| -5 | negate the number after conversion from a string
`write 5=3    `| 0 | equality comparison
`write "test"="test" `| 1 | ditto
`write 5'=3   `| 1 | not equal
`write '5     `| 0 | negate 5| this is zero
`write ''5    `| 1 | negate 5 twice. First a zero, then a one
`write 5>3    `| 1 | Greater than
`write 5'>3    `| 1 | Less than or equal
`write 5<=3    `| 1 | Less than or equal | not standard but works
`write 5<3    `| 0 | Less than
`write 5'<3    `| 0 | Greater than or equal
`write 5>=3   `| 1 | Greater than or equal | not standard but works
`write 5&3    `| 1 | Boolean AND
`write 5&0    `| 0 | Boolean AND
`write 5!0    `| 1 | Boolean OR
`write 0!0    `| 0 | Boolean OR
`write 8]3    `| 1 | 8 follows 3
`write "test"]3 `| 1 | test follows 3.
`write "hello"["lo" |` | 1 | Does "hello" contain "lo"?
`write "2 terrace"]3 `| 0 | 2 terrace does not follow 3.
`write 3?1N`   | 1 | Pattern Match. 3 is 1 number
`write $piece("test1^test2","^",2) `| test2 | function is an expression
`write $$UP^XLFSTR("test1") `| TEST1 | user defined function

A few of these operators need explanation.

Mathematical operators (`*`, `/`, etc.) are all straightforward.

However, you will notice that the `'`, `>`, `<` etc returns 1 or 0. This will
eventually bring us to the typing system of the language, but for now, any
operator that creates a boolean (true or false) returns 1 or 0.

Here are all the boolean operators:

```
= '= ' > '> < '< >= <= ] [ & !
```

Note that M does not have an XOR operator, nor any bitwise operators. All
M implementations provide custom functions to carry such an operation out; but
a strictly string storage language, MUMPS almost 99% of the time never needs
them.

The other thing of note is the fact that some operators only accept one argument.
These are `'`, leading `+`, and leading `-`. These are known as "urnary"
operators. All the others are "binary" operators.

`]` (follows) is like >, expect for strings. "A"]"B" means is A greater than B,
string wise.

Here's something which is extremely unfortunate in MUMPS, but we have to deal
with it: Mathematical operation do not follow the rules of precedence
implemented in almost all other programming languages. Instead, the evaulation
is a strict left to right. For example `3+4*2` would be `7*2=14`. In most other
languages, the result would be `3+8=11`. This is usually very confusing. To
this day I can't get my head around this, so I typically use parentheses to
indicate clearly what I meant, so that future programmers maintaining my code
will be able to read this. For example, `3+(4*2)` gets you the correct result
of 11.

In VISTA and RPMS, there are a few confusing idioms. I will state them here.

`]` is never used except in comparing agains empty strings, which is the
expression `""`. For example, `"test"]""` means `test'=""`. Essentially it's
not equal. This is frequently used to see if a variable contains an empty
string.

`+"6^8^2"` returns 6. Data in Fileman, especially values returned by the ^DIC
API, frequently begin with a number. ^DIC for example may return "3^JOHN
SMITH". Programmers almost always are interested in just the 3. An easy way to
obtain that, rather than using the $piece function (shown in an example above),
is just to + the expression to get the number.

Because Standard MUMPS does not allow >= and <=, '< and '> are used instead.

## The MUMPS typing system
In a programming language, a typing system deals with how data is manipulated
in a program. In MUMPS, for storage on disk, there is only a single type:
string. All data is stored as strings on disk. However, once the data is
loaded into a program, the type of the data is determined by the operation
performed on it. For example, if the variable `x` contains 3 and the variable
`y` contains 6, then `x_y` concatenates two strings, resulting in 36, `x*y`
treats the operands as numbers, and 'x or 'y converts the string into
a boolean. We have already seen above that certain operators (such as > or =)
have an output of boolean. Boolean in MUMPS is not "true" or "false", but 1 or
0. In terms of other programming languages, MUMPS is weakly typed (values do
values do not retain their type between operations) and dynamically typed
(values can be dynamically changed into other types).

Of note, if you haven't noticed it already, strings in MUMPS have to start and
end with a double quote ("). Single quotes, unlike in many other languages
today, cannot be used. The single quote as you saw above is used for negation.

### Canonical forms of data types and resulting comparisons
A string is a string. There is no "canonical form".

Numbers have a canonical form; and it is very important to have a good
understanind of this: Any preceeding zeros before the decimal point, if there
are no other numbers before the decimal point, are stripped; any zeros trailing
the significant figures after a decimal also get stripped.

```
write 3.200000 ; 3.2
write 3.200000*4 ; 12.8
write 00000000003 ; 3
write "3.000"="3" ; 0 ; comparison false as strings
write 3.000=3     ; 1
write 0.5         ; .5
```

The last one (0.5 becoming .5) turns out to be actually a major problem in
medicine. Fractional numbers without a leading zero are a major cause of
medical errors. You as a programmer must attend to formatting this correctly.
You can format it correctly but appending a zero to the front using the
concatenation operator. $Justify and $FNumber are both helpful in that regard
as well. We will discuss these later.

If you inter-op from other programming languages such as Python and Javascript,
you also must attend to this conversion. Most languages today represent the
canonical form of a fraction with a leading zero.

Booleans, as we say before, are plain 1 and 0 for true and false.

### Data type conversion
Conceptually, there is a heirarchy of data type conversions. The highest type
is a String; and the lowest is Boolean. It's helpful to think of conversions
going to String -> Number -> Boolean.

#### String to Numbers
To convert a string to a number, use `+`.

```
write +"hello" ; 0
write +"23 Sanders Lane"; 23
write +"5^SMITH" ; 5
```

#### Number to Boolean
To convert a number to boolean, use `'`.
```
write '5 ; 0
write '0 ; 1
write ''5 ; 1
```
The collarally is that you can convert strings to numbers to booleans.
```
write '"23 Sanders Lane" ; 0
write '"hello" ; 1
```

#### Going the other way
Any of the operators expecting strings will take the values of the other
functions and treat them as strings. For example:
```
write +"23 Sanders Lane"_''5 ; 231
```
Yes. I know. Very odd.


## Variables
A programming language will be pointless if we can't save values for further
manipulation. Variables in M have the following format: a leading letter and
then any number of letters and/or numbers; or a leading % and any number of
letters and/or numbers. For example:
```
test  ; valid
%test ; valid
1test ; invalid
1     ; invalid
```
The current VISTA Standards and Conventions allow a variable to be in any case
and have a maximum length of 16 characters. GT.M and Cache allow a length of
32 characters. Exceeding this does not result in a syntax error, but any
characters following the 32 will not be used to distinguish between labels.

Variables are assigned values using the set command. E.g. `set x=55` or `set
x="hello"`. Unlike other languages, the set command is required to precede
assignment. Variables, like in Javascript, may be optionally scoped using the
`new` command, as in `new x`. If not scoped, they will exist on all levels of
the stack. If scoped, they will exist only on the level you are at and above.
Newing a variable that already exists "shadows" the existing variable, meaning
that its value is saved until you get out of the stack level that you newed.
Examples of this will be shown in the below section

## Stack
