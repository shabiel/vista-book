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

MUMPS suffers from a bad rap because of its obtuse syntax (not really obtuse, but
rather not common in today's popular programming languages), limitations of the
the hardware in the late 1970s and early 1980s, and the obligation to write all code
in uppercase; a result of its history and background. The
absence of variable scoping, anonymous blocks to use with `for` and `if`
commands, and the ability to pass parameters (all of which were remedied in the 1990
M standard) means that early code, much of which is still in operation, is rather unreadable.

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
difference between Caché and GT.M is that Caché does not implement transactions
properly, whereas GT.M provides full ACID compliant transactions. GT.M was born
in the banking sector, where ACID compliance is critical to business
operations, as money transfers need to be exact. Caché does not provide that
guarantee; and in any case, electronic medical records such as VISTA and Epic
were not coded to use transactions. Manuals explicitly tell the users that
in an interrupted session data will be lost; and indeed, frequently it is, from
the experience of the author. As far as the author knows, many of the other
implementations have not implemented transactions. Kevin O'Kane's MDH is unique
in that it has an in-process connection to a Postgres database on the same machine.

In this section, it is worth mentioning the previous major M implementations: 
Digital Standard MUMPS, and Micronetics Standard MUMPS, abbreviated as DSM and MSM.
These were the major platforms on which M ran for VISTA and RPMS. Intersystems,
in an effort to consolidate the market, bought both DSM and MSM.

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

## The M language structure
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

### Code Line
Any line with at least one space or at least one tab at the beginning of the line
is considered a code line. That contains code to be executed. If the code is placed
without a space/tab at the front, the first word in the code will be considered
a line label, and the next argument won't be a command, and thus the interpreter
will complain about a syntax error.

### Formal Lines with a Formal List
In the M 1990 standard, M finally gained the ability to accept parameters to a
procedure or function. So rather then `main`, you can write `main(arg)`, and invoke
it with `do main^helloworld(1)`, where 1 is the arg. This line is known as a formal
line and the parameters are known as a formal list.

### The "Stack"
Since its first days, M implements a virtual (i.e. not implemented in the processor
using an SP register) stack. This stack is incremented every time a procedure or a
function invocation takes place. Once the procedure or function is done, the stack
is decremented back again. 

### Example Program
All right. We need to tie all of these concepts together.
```
circumference ; calculate the circumference of a circle
 ;
 ;
 write "Sorry. No entry from the top is allowed.",!
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
calculate(radius)
 new circ
 set circ=2*3.14*radius ; 2 pi r
 quit circ
 ;
```

