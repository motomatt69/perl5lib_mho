
    #greet('Ingy');
    greet(42);



use Inline C => q{
    void greet(int x) {
    int z;
    z = 4 * x;
      printf("Hello %d!\n", z);
    }
}
