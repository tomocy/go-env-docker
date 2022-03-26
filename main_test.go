package main

import "testing"

func TestEchoSomeArgs(t *testing.T) {
	if err := echo([]string{"./program", "a", "b", "c"}); err != nil {
		t.Errorf("any error must not occure: %+v", err)
	}
}

func TestEchoNoArgs(t *testing.T) {
	if err := echo([]string{"./program"}); err == nil {
		t.Errorf("the 'no args' error must occure: %+v", err)
	}
}
