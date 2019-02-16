Theme default
Columns 2
Title TEST

Button Test {echo "Simple Echo"}
Button Firefox {firefox}
Button "Firefox Google" {firefox https://google.ca}
tclButton tclTest {puts noop}
tclButton AnotherTest {puts noop}
tclButton Button3 {puts noop}
tclButton Yo {puts noop}
Combo "Firefox" firefox {
    https://google.ca
    https://reddit.com
    http://cfl.ca
}

Combo Xterm "xterm -bc" {
    "-e ncmpc"
    "-e tmux"
}
