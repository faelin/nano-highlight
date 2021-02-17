/^+STRING/ {
    r mixins/string.nanorc
    d
}
/^+BOOLEAN/ {
    r mixins/boolean.nanorc
    d
}
/^+FUNCTION/ {
    r mixins/function.nanorc
    d
}
/^+CCOMMENT/ {
    r mixins/ccomment.nanorc
    d
}
/^+HASHCOMMENT/ {
    r mixins/hashcomment.nanorc
    d
}
/^+INI/ {
    r mixins/ini.nanorc
    d
}
/^+RESETALL\>/ {
    r mixins/resetall.nanorc
    d
}
/^+WHITESPACE/ {
    r mixins/whitespace.nanorc
    d
}
/^+TODO/ {
    r mixins/todo.nanorc
    d
}
/^+LINT/ {
    r mixins/lint.nanorc
    d
}
s/^+LONGLINE[[:space:]]*$/WARNING: "^.{80}.+$"/
s/^+LONGLINE\([0-9]\+\)[[:space:]]*$/WARNING: "^.{\1}.+$"/
