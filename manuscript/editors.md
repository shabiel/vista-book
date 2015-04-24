# Editors to use with VISTA
I recommend using any editor as long as you "lint" your code. Linting your code
in VISTA means running XINDEX on it and then checking it for variable leaks.
See below for the linter routine.

 * Cache Studio (part of Cache)
 * On GT.M or Cache/*nix, use vim or emacs in MUMPS mode
 * > To edit: 
 * >> GT.M - just type `zed "routine name"`. GT.M users the `EDITOR`
      environment variable to decide which editor to invoke. To set the editor,
	  using nano for an example, type `export EDITOR=$(which nano)` before you
	  enter GT.M.
 * >> Cache - Use this routine that I wrote: (https://raw.githubusercontent.com/shabiel/random-vista-utilities/master/KBANVIM.m)
 * > To use M mode,
 * >> https://code.google.com/p/lorikeem (Emacs mode)
 * >> https://bitbucket.org/dlw/axiom
 * VPE: https://github.com/shabiel/random-vista-utilities/raw/master/VPE-1.0-1.KID
 * Extensible Editor: Install these:
 * > https://github.com/mdgeek/VistA-RG-Utilities/raw/master/kid/rgut-3.0.kid
 * > https://github.com/mdgeek/VistA-Extensible-Editor/raw/master/kid/rged-3.0.kid
 * Eclipse: Follow these instructions: https://github.com/shabiel/M-Tools-Project

WHICH EVER EDITOR YOU USE, MAKE SURE TO RUN THE LINTER IN THIS KID PACKAGE:
https://raw.githubusercontent.com/shabiel/M-Tools/T12/M-Editor%20For%20Eclipse%20XT_7.3_101%20not%20yet%20released/XT73P101T12.kid

The linter RPC entry point is: `D CHKROU^XTECROU("nameReference","RoutineName","UnitTestRoutine")`
