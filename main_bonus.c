#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct s_list
{
	void          *data;
	struct s_list *next;
}	t_list;

/* ---- prototypes of the assembly bonus functions ------------------------- */
int   ft_atoi_base(char *str, char *base);
void  ft_list_push_front(t_list **begin_list, void *data);
int   ft_list_size(t_list *begin_list)
{
	(void)begin_list;
	return (0);
}
void  ft_list_sort(t_list **begin_list, int (*cmp)())
{
	(void)begin_list;
	(void)cmp;
}
void  ft_list_remove_if(t_list **begin_list, void *data_ref,
		int (*cmp)(), void (*free_fct)(void *))
{
	(void)begin_list;
	(void)data_ref;
	(void)cmp;
	(void)free_fct;
}

/* ---- tiny test harness --------------------------------------------------- */
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

/* ---- helpers ------------------------------------------------------------- */
/* comparison used for sort (ascending) and remove_if (0 == match) */
static int cmp_str(void *a, void *b)
{
	return (strcmp((char *)a, (char *)b));
}

/* free node structs only — use when the data is NOT owned (string literals) */
static void free_nodes(t_list *l)
{
	t_list *next;

	while (l)
	{
		next = l->next;
		free(l);
		l = next;
	}
}

/* free node structs AND their data — use when data was strdup'd */
static void free_all(t_list *l)
{
	t_list *next;

	while (l)
	{
		next = l->next;
		free(l->data);
		free(l);
		l = next;
	}
}

/* true if the list's data matches expected[] in order, and length matches */
static int list_matches(t_list *l, char **expected, int n)
{
	int i = 0;

	while (l && i < n)
	{
		if (strcmp((char *)l->data, expected[i]) != 0)
			return (0);
		l = l->next;
		i++;
	}
	return (l == NULL && i == n);
}

/* ---- ft_atoi_base -------------------------------------------------------- */
static void test_atoi_base(void)
{
	/* NOTE: only single / no signs are tested — multiple-sign behaviour      */
	/* ("--42") differs between implementations, so match it to your ft_atoi. */
	struct { char *str; char *base; int expected; const char *desc; } c[] = {
		{ "42",   "0123456789",       42,  "decimal 42" },
		{ "-42",  "0123456789",      -42,  "negative" },
		{ "+42",  "0123456789",       42,  "leading +" },
		{ "  42", "0123456789",       42,  "leading whitespace" },
		{ "FF",   "0123456789ABCDEF", 255, "hex FF = 255" },
		{ "101",  "01",                5,  "binary 101 = 5" },
		{ "12abc","0123456789",       12,  "stops at first non-base char" },
		{ "xyz",  "0123456789",        0,  "no valid digits -> 0" },
		{ "42",   "",                  0,  "empty base -> 0" },
		{ "42",   "0",                 0,  "single-char base -> 0" },
		{ "42",   "001",               0,  "duplicate in base -> 0" },
		{ "42",   "01+",               0,  "'+' in base -> 0" },
		{ "42",   "01 ",               0,  "whitespace in base -> 0" },
		{ NULL,   NULL,                0,  NULL }
	};

	section("ft_atoi_base");
	for (int i = 0; c[i].str; i++)
		check(ft_atoi_base(c[i].str, c[i].base) == c[i].expected, c[i].desc);
}

/* ---- ft_list_push_front -------------------------------------------------- */
static void test_push_front(void)
{
	t_list *list = NULL;

	section("ft_list_push_front");

	ft_list_push_front(&list, "a");
	check(list != NULL
		&& strcmp(list->data, "a") == 0
		&& list->next == NULL,
		"push into empty list: head set, next is NULL");

	ft_list_push_front(&list, "b");
	check(strcmp(list->data, "b") == 0
		&& list->next != NULL
		&& strcmp(list->next->data, "a") == 0,
		"second push prepends (b -> a)");

	ft_list_push_front(&list, "c");
	{
		char *expected[] = { "c", "b", "a" };
		check(list_matches(list, expected, 3),
			"third push gives order c -> b -> a");
	}

	free_nodes(list);
}

/* ---- ft_list_size -------------------------------------------------------- */
static void test_size(void)
{
	t_list *list = NULL;

	section("ft_list_size");

	check(ft_list_size(NULL) == 0, "empty list has size 0");

	ft_list_push_front(&list, "x");
	check(ft_list_size(list) == 1, "size is 1 after one push");

	ft_list_push_front(&list, "y");
	ft_list_push_front(&list, "z");
	check(ft_list_size(list) == 3, "size is 3 after three pushes");

	free_nodes(list);
}

/* ---- ft_list_sort -------------------------------------------------------- */
static void test_sort(void)
{
	t_list *list = NULL;

	section("ft_list_sort");

	/* sort should not crash on empty or single-element lists */
	ft_list_sort(&list, cmp_str);
	check(list == NULL, "sorting an empty list leaves it empty");

	ft_list_push_front(&list, "solo");
	ft_list_sort(&list, cmp_str);
	check(ft_list_size(list) == 1 && strcmp(list->data, "solo") == 0,
		"sorting a single element is a no-op");
	free_nodes(list);

	/* push banana, cherry, apple  ->  list is apple -> cherry -> banana */
	list = NULL;
	ft_list_push_front(&list, "banana");
	ft_list_push_front(&list, "cherry");
	ft_list_push_front(&list, "apple");
	ft_list_sort(&list, cmp_str);
	{
		char *expected[] = { "apple", "banana", "cherry" };
		check(list_matches(list, expected, 3),
			"sorts unordered strings ascending");
	}
	free_nodes(list);

	/* already sorted should stay sorted */
	list = NULL;
	ft_list_push_front(&list, "3");
	ft_list_push_front(&list, "2");
	ft_list_push_front(&list, "1");   /* list: 1 -> 2 -> 3 */
	ft_list_sort(&list, cmp_str);
	{
		char *expected[] = { "1", "2", "3" };
		check(list_matches(list, expected, 3),
			"already-sorted list stays in order");
	}
	free_nodes(list);
}

/* ---- ft_list_remove_if --------------------------------------------------- */
static void test_remove_if(void)
{
	t_list *list = NULL;
	char    ref[] = "remove";

	section("ft_list_remove_if");

	/* removing from an empty list must not crash */
	ft_list_remove_if(&list, ref, cmp_str, free);
	check(list == NULL, "remove_if on empty list stays empty");

	/* data is strdup'd so free() is a legitimate free_fct.                   */
	/* list ends up: remove -> keep -> remove -> keep (matches at head too)   */
	ft_list_push_front(&list, strdup("keep"));
	ft_list_push_front(&list, strdup("remove"));
	ft_list_push_front(&list, strdup("keep"));
	ft_list_push_front(&list, strdup("remove"));

	ft_list_remove_if(&list, ref, cmp_str, free);
	{
		int ok = (ft_list_size(list) == 2);
		for (t_list *c = list; c; c = c->next)
			if (strcmp(c->data, "keep") != 0)
				ok = 0;
		check(ok, "removes every matching element (including the head)");
	}
	free_all(list);

	/* removing everything should leave the list NULL */
	list = NULL;
	ft_list_push_front(&list, strdup("gone"));
	ft_list_push_front(&list, strdup("gone"));
	{
		char all[] = "gone";
		ft_list_remove_if(&list, all, cmp_str, free);
		check(list == NULL, "removing all elements yields an empty list");
	}

	/* removing nothing should leave the list intact */
	list = NULL;
	ft_list_push_front(&list, strdup("b"));
	ft_list_push_front(&list, strdup("a"));
	{
		char none[] = "zzz";
		ft_list_remove_if(&list, none, cmp_str, free);
		check(ft_list_size(list) == 2, "no match leaves the list unchanged");
	}
	free_all(list);
}

int main(void)
{
	printf(BOLD "libasm bonus test suite" RESET "\n");
	printf(DIM "atoi_base checked against known values; "
		"list functions checked structurally" RESET "\n");

	test_atoi_base();
	test_push_front();
	test_size();
	test_sort();
	test_remove_if();

	printf("\n" BOLD "──  summary  ──" RESET "\n");
	if (g_passed == g_total)
		printf("  " GREEN BOLD "all %d checks passed" RESET "\n\n", g_total);
	else
		printf("  " RED BOLD "%d / %d passed — %d failed" RESET "\n\n",
			g_passed, g_total, g_total - g_passed);

	return (g_passed == g_total ? 0 : 1);
}