int simpleloop (int x, int y) {
  while (x < y) {
    if (x < 3)
      x++;
    else
      x+=2;
  }
  return x;
}
