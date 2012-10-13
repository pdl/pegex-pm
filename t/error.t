# BEGIN { $TestML::Test::Differences = 1 }
# BEGIN { $Pegex::Parser::Debug = 1 }

use TestML -run;

use Pegex;

sub parse {
    my $grammar = (shift)->value;
    my $input = (shift)->value;
    my $parser = pegex($grammar);
    $parser->grammar->tree;
    return $parser->parse($input);
}


__DATA__
%TestML 1.0

# Skipping many error tests until we figure out how to make them fast.
# Plan = 16;
Plan = 5;

*grammar.parse(*input).Catch ~~ *error;

=== Error fails at furthest match
--- grammar
a: b+ c
b: /b/
c: /c/
--- input
bbbbddddd
--- error: "ddddd\n"

### TODO ###
# === Pegex: Illegal meta rule
# --- grammar
# %grammar Test
# %foobar Quark
# a: /a+/
# --- input
# aaa
# --- error: Illegal meta rule

=== Pegex: Rule header syntax error
--- grammar
a|: /a+/
--- input
aaa
--- error: Rule header syntax error

=== Pegex: Rule ending syntax error
--- grammar
a: /a+/ |
--- input
aaa
--- error: Rule ending syntax error

=== Pegex: Illegal rule modifier
--- SKIP
--- grammar
a: /a+/
b: ^<a>1-2
--- input
aaa
--- error: Illegal rule modifier

=== Pegex: Missing > in rule reference
--- SKIP
--- grammar
a: /a+/
b: !<a1-2
--- input
aaa
--- error: Missing > in rule reference

=== Pegex: Missing < in rule reference
--- SKIP
--- grammar
a: /a+/
b: !a>1-2
--- input
aaa
--- error: Missing < in rule reference

=== Pegex: Illegal character in rule quantifier
--- SKIP
--- grammar
a: /a+/
b: !a^1-2
--- input
aaa
--- error: Illegal character in rule quantifier

=== Pegex: Unprotected rule name with numeric quantifier
--- SKIP
--- grammar
a: /a+/
b: !a1-2
--- input
aaa
--- error: Unprotected rule name with numeric quantifier

=== Pegex: Runaway regular expression
--- SKIP
--- grammar
a: /a+
--- input
aaa
--- error: Runaway regular expression

=== Pegex: Illegal group rule modifier
--- SKIP
--- grammar
a: /a+/
b: !(a =<a>)1-2
--- input
aaa
--- error: Illegal group rule modifier

=== Pegex: Runaway rule group
--- grammar
a: /a+/
b: .(a =<a>1-2
--- input
aaa
--- error: Runaway rule group

=== Pegex: Illegal character in group rule quantifier
--- grammar
a: /a+/
b: .(a =<a>)^2
--- input
aaa
--- error: Illegal character in group rule quantifier

=== Pegex: Multi-line error messages not allowed
--- SKIP
--- grammar
a: /a+/
b: `This is legal`
c: `This is
 
illegal`
--- input
aaa
--- error: Multi-line error messages not allowed

=== Pegex: Runaway error message
--- SKIP
--- grammar
a: /a+/
b: `This is legal`
c: `This is

illegal
--- input
aaa
--- error: Runaway error message

=== Pegex: Leading separator form (BOK) no longer supported
--- SKIP
--- grammar
a: /a+/ %%% ~
--- input
aaa
--- error: Leading separator form (BOK) no longer supported

=== Pegex: Illegal characters in separator indicator
--- SKIP
--- grammar
a: /a+/ %%~%%^%% ~
--- input
aaa
--- error: Illegal characters in separator indicator
