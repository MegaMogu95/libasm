#include <stdio.h>

int	ft_atoi_base(char *str, char *base);

int	main(int argc, char **argv)
{
	if (argc != 3)
		return (1);
	printf("ft_atoi_base(str, base) = %d\n", ft_atoi_base(argv[1], argv[2]));
}