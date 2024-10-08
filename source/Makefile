objs = sda.o err.o int.o printf.o
exec = Sda

inst: $(objs)
	ld	-o $(exec) $(objs)
%.o: %.s
	as	$< -o $@ -g
test_printf:
	as printf.s -o printf.o
	ld -o printf_tester printf.o
clean:
	rm	-rf $(objs) $(exec) printf_tester
