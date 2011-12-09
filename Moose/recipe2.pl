package BankAccount;
use Moose;

has 'balance' => (isa => 'Int', is => 'rw', default => 0);

sub deposit{
    my ($self, $amount) = @_;
    $self->balance($self->balance + $amount);
}

sub withdraw{
    my ($self, $amount) = @_;
    my $current_balance = $self->balance();
    ($current_balance >= $amount)
        || confess "Amount overdrawn";
    $self->balance( $current_balance - $amount);
}

package CheckingAccount;
use Moose;

extends 'BankAccount';

has 'overdraft_account' => (isa => 'BankAccount', is => 'rw');

before 'withdraw' => sub {
    my ($self, $amount) = @_;
    my $overdraft_amount = $amount - $self->balance();
    if ($self->overdraft_account && $overdraft_amount > 0) {
        $self->overdraft_account->withdraw($overdraft_amount);
        $self->deposit($overdraft_amount);
    }
};


my $savingsaccount = BankAccount->new(balance => 250);
print $savingsaccount->balance(),"\n";
$savingsaccount->deposit(100);
print $savingsaccount->balance(),"\n";
$savingsaccount->withdraw(200);
print $savingsaccount->balance(),"\n";


my $checkingaccount = CheckingAccount->new(
    balance => 500,
    overdraft_account => $savingsaccount
);
$checkingaccount->withdraw(75);
print $checkingaccount->balance(),"\n";
my $dummy;