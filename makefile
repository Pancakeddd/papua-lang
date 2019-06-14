LUA = luajit
# Can be whatever lua you're using (I'm using luajit, so i'm going to put luajit here.)

all:
	moonc .
	cd src && $(LUA) main.lua