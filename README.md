<h1>experimental</h1>

# my-linux-script

```
bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
```

```
bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
```

# my-linux-script (Debugging)

```
bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/debugging.sh)
```

```
bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/debugging.sh)
```

<details>
<summary><h1>work on</h1></summary>

	number of installed appes : echo $(( $(dpkg-query -l | wc -l) - 5 ))
  	
	shortcut on bspwm & openbox
	
	test down on bspwm & openbox

	spedd up zsh & bash
	
</details>


<details>
<summary><h1>to fix</h1></summary>

	error: tray: Failed to put tray above 0x3800001 in the stack (XCB_MATCH (8))

</details>
