That's right, you can pretty much make your own objects.
And I'm assuming you either want to edit an object or make your own,
so I'll just tell you what everything means.
---------------------------------------------------------------------

"canBeFlipped": whether or not the object can be flipped.
"canCollide": whether or not colliding with the object will cause a
gameover.
"invisible": whether or not the object is invisible.
"canBeScaled": whether or not the object can be scaled to different
sizes.
"triggerMode": 0 = Gets triggered by going past the object. 1 = Gets
triggered by colliding with it. (Make sure canCollide is off for this
one).
---------------------------------------------------------------------

Last but not least, "variables"... "variables" is basically just a
list of extra properties for the object. "variables" can be applied
to any object, even custom ones. They are formated like this:
["variable name", 123] -- 123 is the value. It doesn't have to be a
number. The value can actually be a string like this: "123".
---------------------------------------------------------------------

Hopefully, you understand how object jsons work. If it gets requested
enough, I'll probably make an object editor with a bunch of new
variables.