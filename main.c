#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

extern unsigned long	ft_strlen(const char *s);
extern char				*ft_strcpy(char *dst, const char *src);
extern int				ft_strcmp(const char *s1, const char *s2);
extern ssize_t          ft_write(int fd, const void *buf, size_t count);
extern ssize_t          ft_read(int fd, void *buf, size_t count);
extern char             *ft_strdup(const char *s);

int main(int ac, char **av)
{
    if (ac != 3)
        return (1);
    char    dst[strlen(av[1]) + 1];
    printf("ft_strlen(src1) = %lu\n", ft_strlen(av[1]));
	printf("ft_strcpy(src1) = %s\n", ft_strcpy(dst, av[1]));
    printf("ft_strcmp(src1, src2) = %d\n", ft_strcmp(av[1], av[2]));
    printf("strcmp(src1, src2) = %d\n", strcmp(av[1], av[2]));
    ft_write(1, av[1], ft_strlen(av[1]));
    ft_write(1, "\n", 1);
    int fd = open("./file", O_RDWR);
    if (ft_write(fd, "garbage", 2) < 0)
        perror("");
    if (ft_read(fd, dst, ft_strlen(av[1])) < 0)
        perror("");
    printf("%ld\n", ft_read(0, dst, ft_strlen(dst) + 1));
    printf("%s\n", ft_strdup("Bonjour tout le monde"));
    return 0;
}