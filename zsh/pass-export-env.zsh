
pass-env() {
    for line in $(pass $1)
    do 
        export $line
    done

}
