import 'dart:math';

class Node
{
  int rowPos, colPos;
  int GValue, FValue;

  Node(this.rowPos,this.colPos, this.GValue, this.FValue);




  int getGValue()
  {
    return GValue;
  }

  int getFValue()
  {
    return FValue;
  }

  void updateGValue(int i)
  {
    GValue += ((i % 2 == 0 ? 10 : 14));
  }

  void calculateFValue(int row, int col)
  {
    FValue = GValue + getHValue(row, col);
  }

  int getHValue(int row, int col)
  {
    int dx, dy;

    dx = col - colPos;
    dy = row - rowPos;

    return (14*sqrt(dx*dx + dy*dy)).toInt();

  }
}