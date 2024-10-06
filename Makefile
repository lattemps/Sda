objs = inst.o fatal.o interpreter.o printf.o
exec = inst


inst: $(objs)
	ld	-o $(exec) $(objs)
%.o: %.s
	as	$< -o $@

test_printf:
	as printf.s -o printf.o
	ld -o printf_tester printf.o

clean:
	rm	-rf $(objs) $(exec) printf_tester
