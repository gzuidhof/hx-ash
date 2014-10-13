=======
hx-ash
========

[![Build Status](https://travis-ci.org/Rahazan/hx-ash.svg)](https://travis-ci.org/Rahazan/hx-ash)

----
Fork/continuation of https://github.com/nadako/Ash-HaXe.

This is a HaXe port of the awesome Ash entity component framework by Richard Lord (http://www.ashframework.org/).
It leverages HaXe's great cross-platform portability and runs on Flash, JavaScript, C++, Android, iOS and so on.
Also it uses much static typing features of HaXe, allowing more mistakes to be detected at compile time instead
of runtime than in original ActionScript 3 version.

Check out original [Ash website](http://www.ashframework.org/) for great articles on entity frameworks and game development.

**TODO:**

 * Port serialization stuff. This is kind of tricky because original Ash uses reflection and we are trying to avoid it, so we gotta be smart about macros.
 * Refine access control for private classes and fields. Original Ash used internal class/field feature of AS3, in Haxe we need to use ACL metadata.
 * Review generacted code on performance, add inlines (especially important to inline iterators)

----
**Install**

    haxelib install hx-ash

----
**CHANGES from original port:**
 * [Dead Code Elimination fix by eliasku.](https://github.com/nadako/Ash-HaXe/pull/16)
 * Unit tests using std haxe.unit. Allows for automated travis-ci builds. *Note that some of this port was done automatically by some scripts (some beauty flaws in code).*
 * [Entity unique IDs that can be used to retrieve them](https://github.com/Rahazan/hx-ash/pull/1), contributed by theor.
 * Support for Java target. Useful if you want to target dalvik.

**TODO**
 * Maybe make the switch to MSignal.
 * Check whether example is still functional

----
**Contributors**

Dan Korstelev, Elias Ku, Guido Zuidhof, theor


