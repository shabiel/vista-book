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

The language was standardized by ANSI and ISO in 1977. Due to this, its medical
background, and its suitability for representing multifaceted medical data, it
remains a very common language in medical informatics. Much of how it ended up
that way is due to various pioneers, notably Ted O'Neil, who envisioned the
application of computing to medicine.

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

I will be making frequent references to
http://www.vistaexpertise.net/docs/pocket_guide.pdf. This is a pocket guide
that can be perused to give you detailed information on a specific syntax. This
is published by VISTA Expertise Network, my employer.

## The Units of Execution
Before getting into MUMPS, it worth noting some terminology.

A program in MUMPS is called a routine. Better get used to it.

A routine operates on data located in *global* variables. Global variables, are
not, like in almost any other programming language I know, variables are are
scoped to be shared by all execution units (routines); but rather, variables
which are stored on disk. Variables that are not global variables are called
local variables, and they exist for the duration of execution. Local variables
may be shared across all execution units (routines), but they are still called
local variables.

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

All right. We need to tie all of these concepts together.
```
circumference ; calculate the circumference of a circle ; label line
 ; level line
 ;
 write "Sorry. No entry from the top is allowed.",! ; level line
 quit
 ;
main ; Main entry point
 read "type enter to begin: ",x,!
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
`write 3/4 `| .75 | / is divide. Divisions in M return the decimals
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
`write "hello"["lo"` | 1 | Does "hello" contain "lo"?
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
Variables in MUMPS come in two varaities: Local and Global, before we get to
them though, a word on the ^ character.

### ^ (Caret, Up-Caret, Circumflex)
Everytime I taught MUMPS, a big source of confusion for students is the "^"
character, since it appears in so many contexts and has difference meanings in
different places. I will try to clarify the different meanings so we won't get
confused going forward.

In variables, a local variable is not preceded by the ^, where as a global
variable (a variable stored on disk) is. In any context where data is examined,
read, or written, that is the meaning of the ^.

In routine invocation and in routine examination statements, an ^ stands for
a routine name. In any context where a routine is invoked, or examined, the
^ stands for "what follows me is a routine name".

How do we know which is which? It depends on the command that preceed the
expression. If the command is `DO` or `GOTO`, the argument that contains the
^ is a routine reference; the `$TEXT` function takes a routine reference as
well. In ALL other contexts, the ^ means that it's a global variable.

Here are a few examples.

In the examples below, the colon (:) is a post conditional. It is similar to
Python and Ruby statements that do something similar. E.g., in Python, this is
valid code: `x if C else y`. This can get even fancier in Python. In MUMPS,
do:^item1 ^item2 means that if ^item1 (as a variable) is true, run ^item2.
A more obtuse post conditional, which I informally like to call the "post-post"
coditional, is when the condition postcedes the variable. See the goto example
below.

```
do ^item ; routine
do:^item1 ^item2 ; ; item1 is a global; item2 is a routine
goto ^item2:^item1 ; item2 is a routine, item1 is a global.
write ^item1 ; item1 is a global
write:^item1 ^item2 ; both item1 and item2 are globals
if ^item1  ; ^item1 is a global
write $text(^item1) ; ^item1 is a routine
write $extract(^item1) ; ^item1 is a routine
```

So let's summarized this for carets in front of an identifier: Arguments of
`DO` and `GOTO` are routines; parameters to the function $TEXT are also
routines. Everything else is a global.

### Local Variables
A programming language will be pointless if we can't save values for further
manipulation. Local Variables in M have the following format: a leading letter and
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
characters following the 32 will not be used to distinguish between variables.

Variables are assigned values using the set command. E.g. `set x=55` or `set
x="hello"`. Unlike other languages, the set command is required to precede
assignment. Variables, like in Javascript, may be optionally scoped using the
`new` command, as in `new x`. If not scoped, they will exist on all levels of
the stack. If scoped, they will exist only on the level you are at and above.
Newing a variable that already exists "shadows" the existing variable, meaning
that its value is saved until you get out of the stack level that you newed.
Examples of this will be shown in the below section

### Global Variables
In pretty much every other programming language I know, global variables are
those whose scope encompasses the whole operating systme thread. When I learned
MUMPS, trying to fit that definition into what MUMPS called "globals" was a bit
difficult for me. Globals in MUMPS are really very simple: They are the files
on the disk. When you set a global using a set statement (just like the local
variables), the MUMPS Virtual Machine writes that to disk. Local variables only
exist in the memory of the system in that process's address space. When the
process goes away, and then you start another MUMPS process, you won't find
local variables but you will find the global variables on disk. A simple
example: `set ^x=55`.

### Variable Trees (commonly known as arrays)
I would try very hard to not call these arrays, because they have absolutely
nothing in common with any other arrays I know of in other languages; but that
name has stuck.

In MUMPS, an array is really a tree structure of branches at which the tips
(nodes) have values which get stored in memory (locals) or on disk (globals).
I really can't explain it without an example (we are going British with the
name components here):

```
 ^persons(1,"name")="Habiel,Samuel"
 ^persons(1,"name","components","surname")="Habiel"
 ^persons(1,"name","components","given")="Samuel"
 ^persons(1,"address","street1")="123 Bunny Lane"
 ^persons(1,"address","city")="Seattle"
 ^persons(1,"address","postalCode")="12345"
 ^persons(1,"address","country")="US"

 ^persons(2,"name")="Granger,Hermione"
 ^persons(2,"ethnicity")="Caucasion"
 ^persons(2,"address","street1")="123 Hogwarts Street"
 ^persons(2,"address","street2")="Griffindor House"
 ^persons(2,"address","street3")="Flat No 88"
 ^persons(2,"address","city")="Hogwarts Castles"
 ^persons(2,"address","postalCode")="A1E K2N"
 ^persons(2,"address","country")="GB"

 ^persons(3,"...

 ^persons("NameIndex","HABIEL,SAMUEL",1)=""
 ^persons("NameIndex","GRANGER,HERMIONE",2)=""
 ^persons("NameIndex",...

 ^persons("EthnicityIndex","CAUCASION",2)=""
 ...
```

The first thing that will jump at you (it certainly did for me when I first saw
this) is that these are not arrays. Arrays have elements that are addressable
by numbers, arrays are splitable, and arrays have a finite length. None of this
is true here. Instead, we something that resembles a key-value store, but it
looks like that there are multiple keys. And strangely, keys do not have to be
present in difference records.

The last point is the most important to the existence of MUMPS in medicine.
Such arrays (alas we have to use the name now) are called sparse arrays. The
most advanced technologies of the data in data storage, even early relational
databases, stored data in fixed length records. You were expected to have an
entry for each item in the record; if it is empty, you still have to keep
a space where the record should be. In MUMPS, that is not the case. You can
have as little or as much of the data as you like; and you won't consume any
storage for data that you do not have. This in a nutshell is what MUMPS
succeeded in medicine. Patient data is very sparse and multidimentinal. We
mentioned in the introduction the problem of having to store multiple vitals
for patients when vitals can be performed in a combination of different
attributes (supine/upright, left/right, brachial/radial, resting/exercise), and
where most patients will not have the same combination of attributes. Storing
this in a flat file system will be rather expensive. Remember, that was the
1970's and 80's. Today... well, let's just say we have Blu-ray movies, each one
clocks at about 50GB.

So enough of why and whence. Let's examine the structure of the globals above.
--TODO: CONTINUE--

## Stack
MUMPS implements a virtual stack... Never mind the virtual; just a stack.
The stack levels are numbered, and they start at 0. The stack gets incremented
by calling a new block of code using `DO`, running a user created function
using `$$`, or excuting a string as code, using the `XECUTE` command. Don't
worry about these concepts. We will get to them in due time.  The stack is very
important for debugging: it shows a complete "staircase" for how you got into
a statement that caused an error. I will present two examples, one of the
routine we saw above; and one showing an error trap in VISTA, which displays
the entire stack for debugging.

### Example 1
Invoke using main^circumference directly from the Operating System shell.
Running it from programmer mode adds a stack level because programmer mode is
itself considered a stack item.
```
circumference ; calculate the circumference of a circle 
 ; 
 write "Sorry. No entry from the top is allowed.",!
 quit
 ;
main ; Main entry point
 ; *Stack Level 0*
 read "type enter to begin: ",x,!
 write !!
 new circ set circ=0
 read "Enter a radius: ",rad,!
 write !!
 set circumference=$$calculate(rad)
 write "circumference is "_circumference,!
 quit
 ;
calculate(radius) ;
 ; *Stack Level 1*
 new circ ; this variable has the same name as the variable above, but it is
          ; newed here. It "shadows" the original variable, so you do not have
          ; access to the original variable until you exit out of this stack
          ; level.
 set circ=2*3.14*radius ; 2 pi r
 quit circ
 ;
```
### Example 2
This is an example of a KIDS installation gone bad. We check the error trap.

```
PACKAGE: PX*1.0*201     Feb 01, 2015 11:19 am                         PAGE 1
                                             COMPLETED           ELAPSED
-------------------------------------------------------------------------------
STATUS: Start of Install                  DATE LOADED: FEB 01, 2015@10:55:12
INSTALLED BY: PROGRAMMER,ONE
NATIONAL PACKAGE: PCE PATIENT CARE ENCOUNTER

INSTALL STARTED: FEB 01, 2015@10:56:38

ROUTINES:                                    10:56:38

PRE-INIT CHECK POINTS:
XPD PREINSTALL STARTED                       10:56:38
XPD PREINSTALL COMPLETED                     10:56:38

FILES:
VACCINE INFORMATION STATEMENT                10:56:38
IMMUNIZATION INFO SOURCE                     10:56:38
IMM ADMINISTRATION ROUTE                     10:56:38
IMM ADMINISTRATION SITE (BODY)               10:56:38
V IMMUNIZATION                               10:56:38
IMM MANUFACTURER                             10:56:38
IMMUNIZATION                                 10:56:38
IMMUNIZATION LOT                             10:56:38

OPTION                                       10:56:39             0:00:01

POST-INIT CHECK POINTS:
XPD POSTINSTALL STARTED
XPD POSTINSTALL COMPLETED

INSTALL QUESTION PROMPT                                               ANSWER

XPO1   Want KIDS to Rebuild Menu Trees Upon Completion of Install     NO
XPI1   Want KIDS to INHIBIT LOGONs during the install                 NO
XPZ1   Want to DISABLE Scheduled Options, Menu Options, and Protocols NO
MESSAGES:

 Install Started for PX*1.0*201 :
               Feb 01, 2015@10:56:38

Build Distribution Date: Nov 04, 2014

 Installing Routines:
               Feb 01, 2015@10:56:38

 Running Pre-Install Routine: PRE^PXVP201

 Installing Data Dictionaries:
               Feb 01, 2015@10:56:38

 Installing Data:
               Feb 01, 2015@10:56:39

 Installing PACKAGE COMPONENTS:

 Installing OPTION
               Feb 01, 2015@10:56:39

 Running Post-Install Routine: POST^PXVP201

<UNDEFINED>KUPXREF+13^BIUTL5 *Z
```

To display the error trap in VISTA after a crash, run `DO ^XTER`. Look at the
$STACK variable array. While there is a lot that is not obvious, you can
clearly see the incrementing stack. Please note that `D` is an abbreviation of
`DO` and `X` `XECUTE`.


```
Process ID:  6915  (6915)               FEB 01, 2015 10:56:39
UCI/VOL: [ROU:CACHEINV]                 
$ZA:   0                                $ZB: \013
Current $IO: /dev/pts/3                 Current $ZIO: #.#.#.#^43^19^/dev/
pts/3
$ZE= <UNDEFINED>KUPXREF+13^BIUTL5 *Z
Last Global Ref: ^UTILITY("DIK",6915,9999999.14,.02,3)
 S @(BIGBL_"""""_Z_"""",$E($$UPPER(X),1,30),DA)")=""
$DEVICE=
$ECODE=,M6,
$ESTACK=17
$ETRAP=D ERR^XPDIJ
$QUIT=0
$STACK=20
$STACK(000)=
$STACK(000,"ECODE")=
$STACK(000,"PLACE")=@ +1
$STACK(000,"MCODE")=D ^XUP
$STACK(001)=DO
$STACK(001,"ECODE")=
$STACK(001,"PLACE")=ZIS2+9^XUP +3
$STACK(001,"MCODE")= D KILL1^XUSCLEAN S $P(XQXFLG,U,3)="XUP" D ^XQ1
$STACK(002)=DO
$STACK(002,"ECODE")=
$STACK(002,"PLACE")=R+2^XQ1 +1
$STACK(002,"MCODE")= D @XQZ G OUT
$STACK(003)=DO
$STACK(003,"ECODE")=
$STACK(003,"PLACE")=EN+19^XPDIJ +5
$STACK(003,"MCODE")= F  S Y=$O(^XPD(9.7,"ASP",XPDA,Y)) Q:'Y  S %=$O(^(Y,0)) D:% 
 Q:$D(XPDABORT)
$STACK(004)=DO
$STACK(004,"ECODE")=
$STACK(004,"PLACE")=EN+22^XPDIJ +3
$STACK(004,"MCODE")= .S XPDA=%,XPDNM=$P($G(^XPD(9.7,XPDA,0)),U) D IN^XPDIJ1 Q:$D
(XPDABORT)
$STACK(005)=DO
$STACK(005,"ECODE")=
$STACK(005,"PLACE")=IN+23^XPDIJ1 +1
$STACK(005,"MCODE")= D POST:$G(XPDT("MASTER"))'=XPDA
$STACK(006)=DO
$STACK(006,"ECODE")=
$STACK(006,"PLACE")=POST+2^XPDIJ1 +2
$STACK(006,"MCODE")= I '$$VERCP^XPDUTL("XPD POSTINSTALL COMPLETED") D  Q:$D(XPDA
BORT)
$STACK(007)=DO
$STACK(007,"ECODE")=
$STACK(007,"PLACE")=POST+7^XPDIJ1 +5
$STACK(007,"MCODE")= .F  S XPDCHECK=$O(^XPD(9.7,XPDA,"INIT",XPDCHECK)) Q:'XPDCHE
CK  S XPD=^(XPDCHECK,0) D  Q:$D(XPDABORT)
$STACK(008)=DO
$STACK(008,"ECODE")=
$STACK(008,"PLACE")=POST+15^XPDIJ1 +1
$STACK(008,"MCODE")= ..D @XPDRTN
$STACK(009)=DO
$STACK(009,"ECODE")=
$STACK(009,"PLACE")=POST+13^PXVP201 +1
$STACK(009,"MCODE")= D DATA  ;restores backup
$STACK(010)=DO
$STACK(010,"ECODE")=
$STACK(010,"PLACE")=DATA+4^PXVP201 +4
$STACK(010,"MCODE")= F J=0:0 S J=$O(^AUTTIMM(J)) Q:J'>0  D
$STACK(011)=DO
$STACK(011,"ECODE")=
$STACK(011,"PLACE")=DATA+5^PXVP201 +3
$STACK(011,"MCODE")= . S DA=J,DIK="^AUTTIMM(" D ^DIK
$STACK(012)=DO
$STACK(012,"ECODE")=
$STACK(012,"PLACE")=EN^DIK1 +2
$STACK(012,"MCODE")=EN N DIC D DI
$STACK(013)=DO
$STACK(013,"ECODE")=
$STACK(013,"PLACE")=DIN^DIK1 +5
$STACK(013,"MCODE")=DIN S DV=0 F  S DV=$O(^UTILITY("DIK",DIKJ,DH,DV)) Q:DV=""  D
 R:$G(DIKSET)!(DV-.01)
$STACK(014)=DO
$STACK(014,"ECODE")=
$STACK(014,"PLACE")=XEC^DIK1 +3
$STACK(014,"MCODE")=XEC S DW=$O(^UTILITY("DIK",DIKJ,DH,DV,DW)) Q:DW=""  D NXEC(^
(DW)) S X=DIKS G XEC
$STACK(015)=DO
$STACK(015,"ECODE")=
$STACK(015,"PLACE")=NXEC+4^DIK1 +1
$STACK(015,"MCODE")= X DICODE
$STACK(016)=XECUTE
$STACK(016,"ECODE")=
$STACK(016,"PLACE")=@ +1
$STACK(016,"MCODE")=D KUPXREF^BIUTL5(X,"^AUTTIMM(")
$STACK(017)=DO
$STACK(017,"ECODE")=,M6,
$STACK(017,"PLACE")=KUPXREF+13^BIUTL5 +1
$STACK(017,"MCODE")= S @(BIGBL_"""""_Z_"""",$E($$UPPER(X),1,30),DA)")=""
$STACK(018)=DO
$STACK(018,"ECODE")=
$STACK(018,"PLACE")=ERR+3^XPDIJ +1
$STACK(018,"MCODE")= D ^%ZTER,BMES^XPDUTL(XPDERROR),EXIT^XPDID()
```
## Example code so that we can dig in.
--TODO--

## Built-In Functions
I call these built-in functions for ease of understanding compared with modern
languages, but in the MUMPS Standard they are called "Instrinsic" functions. Any
user defined functions (including those defined in libraries) are "Extrinsic"
functions. Many programming languages do not provide a way for you to figure
out what's built-in and what is definied explicitly by another programmer as
a function, but in MUMPS, it's very simple. $FunctionName is a built-in
function, and $$FunctionName^LibaryName is a user-defined function in
a library. In this section, we will not discuss every single function, but we
will cover the most important ones, and then give a listing of unimportant ones
which can be perused at the reader's pleasure in the aforementioned MUMPS
Handbook.

There are a few functions we will dicuss later in their appropriate sections.
E.g., $Data and $Order are best discussed in dealing with globals. We will
start with the most important functions and work our way down.

The examples below will only use the `write` command, which we covered above

### $Piece, $P
$Piece is proabably by far the most commonly used function in all of VISTA.
This is because all of VISTA's data storage and API output returns data
delimited by "^". In VISTA, almost always you see the "^" as the variable U.
U is assigned first thing when you log-in, so it is guaranteed to be always
available.

Let's look at an example. The below is the first two data nodes for patient
1 in a VISTA instance. ^DPT is the patient global, 1 is the record number, and
each node stores data. Here there are two nodes. 

```
^DPT(1,0)="ZZ PATIENT,TEST ONE^F^2450124^^2^^NOE^^000003322^^LAS VEGAS^32^^^68^3060511^^^^1"
^DPT(1,.11)="12 WAYLAND AVE^^^BROOKLYN^36^11234^70^^^^^11234^3050223.171822^VAMC^050^^14"
```

On the "0" node, we have the first "^" piece as the patient name, the second
the patient sex, and the thrid the patient date of birth. I won't go into
a tangent on the Fileman date format, but trust me, this is a date.

To get the patient name, you can do this:

```
write $piece(^DPT(1,0),"^",1) ;ZZ PATIENT,TEST ONE
```

If you don't specify the piece number, it will default to 1. For example,

```
write $piece(^DPT(1,0),"^") ;ZZ PATIENT,TEST ONE
```

The patient's sex can be obtained by specifying the second piece:

```
write $piece(^DPT(1,0),"^",2) ; F
```

When in VISTA, you will typically see this (we will abbreviate write as W):

```
W $P(^DPT(1,0),U,2) ; F
```

In VISTA, almost always the commands are abbreviated. Which brings us to
another unfortunate point for beginners in the language. All the commands in
the code are abbreviated. It's a pretty difficult thing to get used it when
starting, but eventually, eventually...

One last thing regarding $Piece: in other programming languages, most often
what you will see is an operation to break a string into an array, then a way
to extract an element of an array. Cf. Javascript's `split` method.

### $Length, $L
$Length is pretty straight forward. Write $Length("test") will get you 4.
However, the interesting thing about $Length is that it has a 2 argument form
that actually changes its behavior. A 2 argument $Length counts the number of
pieces in a string when broken by the delimiter in the second argument. So,

```
write $length("test^data^again","^") ; 3
```

This command you may surmise is useful in combination of $Piece and the For
command. Knowing the number of pieces helps us know when to stop looping for
pieces.

### $Extract, $E
$Extract gets you a part of the string you specify. In a lot of other
languages, this function is called a substring. $Extract has three formats:
One, two and three argument format. I will leave it for the examples to teach.

```
W $E("str") ; s
W $E("str",1) ; s
W $E("str",2) ; t
W $E("str",1,2) ; st
W $E("str",2,3) ; tr
W $E("str",1,$L("str")) ; str
W $E("str",1,$L("str")-1) ; st
```

### $Char ($C) and $ASCII ($A)

I hope you are familiar with the ASCII table. If not, take a look at wikipedia.

$Char is used to print non-visible characters from the ASCII table. For
example, to issue a bell to the screen (something really annoying that VISTA
does too many times... please don't do it), you write `W $C(7)`. The other
common strings to write with $Char are the Line feed, carriage return
combination, to create a new line: $C(13,10). You will notice that you can
actually combine characters in $Char by using a comma. You can use (but there
is no reason to) $Char to print out a visible character. E.g. $C(65) will print
an uppercase "A".

$ASCII flips this operation around. You tell it what printable character you
want (or read in from the user), and you can print its ASCII numerical value.
($Char accepts the numeric value and spits out the character to the screen).
$ASCII can take one or two variables. See below for the examples.

For example,

```
write $ascii("A") ; 65
W $A(" ") ; 32 (space)
W $A("ABCDE") ; 65, A
W $A("ABCDE",5) ; 69, E, it is the fifth letter, and we asked for the fifth.
```

### $Translate, $TR
$Translate changes some characters or deletes them. It is often used to format
data from other sources coming into VISTA. It comes in a 2 argument and a three
argument form.

For example, if `^DPT(1,0)="ZZ PATIENT,TEST ONE^F^2450124^`, then
```
W $TR(^DPT(1,0),


### $Get

### $Text

### $Justify

### $FNumber


### $Random

### $Name

### More
$FIND - Rarely used.
$REVERSE - Rarely used.
$Order
$Data
$Query
$QuerySubscript
$QueryLength
