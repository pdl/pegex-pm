# BEGIN { $TestML::Test::Differences = 1 }
# BEGIN { $Pegex::Parser::Debug = 1 }

use TestML -run,
    -require_or_skip => 'YAML::XS';

use Pegex::Compiler;
use YAML::XS;

sub compile {
    my $grammar_text = (shift)->value;
    Pegex::Compiler->new->parse($grammar_text)->tree;
}

sub yaml {
    return YAML::XS::Dump((shift)->value);
}

__DATA__
%TestML 1.0

Plan = 2;

*grammar1.compile.yaml == *grammar2.compile.yaml;

=== Simple Test Case
--- grammar1
a: /x/
--- grammar2
a:
    /x/

=== And over Or Precedence
--- grammar1
a: b c | d
--- grammar2
a: ( b c ) | d