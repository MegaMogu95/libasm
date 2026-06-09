#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

size_t   ft_strlen(const char *s);
char    *ft_strcpy(char *dst, const char *src);
int      ft_strcmp(const char *s1, const char *s2);
ssize_t  ft_write(int fd, const void *buf, size_t count);
ssize_t  ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *s);

#define GREEN "\033[0;32m"
#define RED   "\033[0;31m"
#define CYAN  "\033[0;36m"
#define BOLD  "\033[1m"
#define DIM   "\033[2m"
#define RESET "\033[0m"

static int g_total = 0;
static int g_passed = 0;

static void section(const char *name)
{
	printf("\n" BOLD CYAN "──  %s  ──" RESET "\n", name);
}

static void check(int ok, const char *desc)
{
	g_total++;
	if (ok)
	{
		g_passed++;
		printf("  " GREEN "✓" RESET " %s\n", desc);
	}
	else
		printf("  " RED "✗  %s" RESET "\n", desc);
}

static int sign(int x)
{
	return ((x > 0) - (x < 0));
}

static void test_strlen(void)
{
	const char *cases[] = {
		"", "a", "hello world",
		"a slightly longer string used to exercise the loop a bit more",
		NULL
	};

	section("ft_strlen");
	for (int i = 0; cases[i]; i++)
	{
		char label[128];
		snprintf(label, sizeof label, "len(\"%.20s%s\") == %zu",
			cases[i], strlen(cases[i]) > 20 ? "…" : "", strlen(cases[i]));
		check(ft_strlen(cases[i]) == strlen(cases[i]), label);
	}
}

static void test_strcpy(void)
{
	const char *cases[] = { "", "x", "copy this please", NULL };

	section("ft_strcpy");
	for (int i = 0; cases[i]; i++)
	{
		char mine[256];
		char ref[256];
		char *r = ft_strcpy(mine, cases[i]);

		strcpy(ref, cases[i]);
		check(r == mine, "returns the destination pointer");
		check(memcmp(mine, ref, strlen(cases[i]) + 1) == 0,
			"copies the bytes and the terminating '\\0'");
	}
}

static void test_strcmp(void)
{
	/* a high-bit byte (0x80 = 128) vs a low one checks unsigned comparison  */
	static const char hi[] = { (char)0x80, 0 };
	static const char lo[] = { 0x01, 0 };

	struct { const char *a; const char *b; } cases[] = {
		{ "hello", "hello" },
		{ "hello", "world" },
		{ "world", "hello" },
		{ "abc",   "abcd"  },
		{ "abcd",  "abc"   },
		{ "",      ""      },
		{ "",      "a"     },
		{ hi,      lo      },   /* must be POSITIVE: 128 > 1 as unsigned char */
		{ NULL,    NULL    }
	};

	section("ft_strcmp");
	for (int i = 0; cases[i].a; i++)
	{
		int mine = ft_strcmp(cases[i].a, cases[i].b);
		int ref  = strcmp(cases[i].a, cases[i].b);
		check(sign(mine) == sign(ref), "sign matches strcmp");
	}
}

static void test_write_read(void)
{
	int fds[2];
	const char *msg = "round trip through a pipe";
	size_t n = strlen(msg);
	char buf[128] = {0};

	section("ft_write & ft_read");

	if (pipe(fds) == -1)
	{
		check(0, "pipe() setup failed — skipping round trip");
	}
	else
	{
		ssize_t w = ft_write(fds[1], msg, n);
		check(w == (ssize_t)n, "ft_write returns the byte count");

		ssize_t r = ft_read(fds[0], buf, n);
		check(r == (ssize_t)n && memcmp(buf, msg, n) == 0,
			"ft_read reads back exactly what was written");

		close(fds[0]);
		close(fds[1]);
	}

	/* error path: a bad file descriptor must return -1 and set errno like   */
	/* the real syscall does (EBADF). We compare ft_ errno against libc errno */
	errno = 0;
	ssize_t mw = ft_write(-1, msg, n);
	int     ew = errno;
	errno = 0;
	ssize_t lw = write(-1, msg, n);
	int     el = errno;
	check(mw == -1 && lw == -1 && ew == el,
		"ft_write on bad fd: returns -1 and sets errno like write");

	errno = 0;
	ssize_t mr = ft_read(-1, buf, n);
	int     er = errno;
	errno = 0;
	ssize_t lr = read(-1, buf, n);
	int     elr = errno;
	check(mr == -1 && lr == -1 && er == elr,
		"ft_read on bad fd: returns -1 and sets errno like read");
}

static void test_strdup(void)
{
	const char *src = "duplicate me, then leave me untouched";

	section("ft_strdup");

	char *dup = ft_strdup(src);
	check(dup != NULL, "returns a non-NULL pointer");
	if (dup)
	{
		check(dup != src, "returns a NEW buffer, not the original pointer");
		check(strcmp(dup, src) == 0, "the copy has identical content");

		/* mutating the copy must not affect the source — proves a real copy */
		dup[0] = 'X';
		check(src[0] == 'd', "the original is independent of the copy");

		free(dup);
	}
}

int main(void)
{
	printf(BOLD "libasm test suite" RESET "\n");
	printf(DIM "each ft_ function is checked against its libc twin" RESET "\n");

	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write_read();
	test_strdup();

	printf("\n" BOLD "──  summary  ──" RESET "\n");
	if (g_passed == g_total)
		printf("  " GREEN BOLD "all %d checks passed" RESET "\n\n", g_total);
	else
		printf("  " RED BOLD "%d / %d passed — %d failed" RESET "\n\n",
			g_passed, g_total, g_total - g_passed);

	return (g_passed == g_total ? 0 : 1);
}