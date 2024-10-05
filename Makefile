objs = inst.o fatal.o
exec = inst

all: $(exec)

$(exec): $(objs)
	ld	-o $(exec) $(objs)

%.o: %.s
	as	$< -o $@

clean:
	rm	-rf $(objs) $(exec)
