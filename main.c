#include <stdio.h>
#include <string.h>

extern unsigned long	ft_strlen(const char *s);
extern char				*ft_strcpy(char *dst, const char *src);
extern int				ft_strcmp(const char *s1, const char *s2);

int main(int ac, char **av)
{
    if (ac != 3)
        return (1);
    char    dst[strlen(av[1]) + 1];
    printf("ft_strlen(src1) = %lu\n", ft_strlen(av[1]));
	printf("ft_strcpy(src1) = %s\n", ft_strcpy(dst, av[1]));
    printf("ft_strcmp(src1, src2) = %d\n", ft_strcmp(av[1], av[2]));
    printf("strcmp(src1, src2) = %d\n", strcmp(av[1], av[2]));
    return 0;
}