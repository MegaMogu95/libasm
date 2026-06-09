NAME    = tester
BNAME	= tester_bonus
LIB		= libasm.a
BLIB	= blibasm.a
SRCS    = lib/ft_strlen.s lib/ft_strcpy.s lib/ft_strcmp.s lib/ft_write.s lib/ft_read.s lib/ft_strdup.s
OBJS    = $(SRCS:.s=.o)
BSRCS	= lib/ft_atoi_base.s lib/ft_list_push_front.s lib/ft_list_size.s lib/ft_list_sort.s	lib/ft_list_remove_if.s
BOBJS	= $(BSRCS:.s=.o)

all: $(LIB)
	cc -Wall -Wextra -Werror -o $(NAME) $(LIB) $(OBJS) main.c

bonus: $(BLIB)
	cc -Wall -Wextra -Werror -std=gnu11 -o $(BNAME) $(BLIB) $(OBJS) $(BOBJS) main_bonus.c

%.o: %.s
	nasm -f elf64 -g $< -o $@

$(LIB): $(OBJS)
	ar rcs $(LIB) $(OBJS)

$(BLIB): $(OBJS) $(BOBJS)
	ar rcs $(BLIB) $(OBJS) $(BOBJS)

clean:
	rm -f $(OBJS) $(BOBJS)

fclean: clean
	rm -f $(NAME) $(BNAME)
	rm -f $(LIB) $(BLIB)

re: fclean all

.PHONY: all clean fclean re bonus