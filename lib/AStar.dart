import 'Node.dart';
import 'package:collection/collection.dart';
import 'TestGrid.dart';
import 'package:vector_math/vector_math.dart';

const int NDIR = 8;

// Il primo valore si riferisce alla cella in alto al centro
List<int> iDir = [ 1, 1, 0, -1, -1, -1, 0, 1 ]; // AsseY
List<int> jDir = [ 0, 1, 1, 1, 0, -1, -1, -1 ]; // AsseX

class AStar{


  List<Vector2> aStar(List<List<int>> gridMatrix, int startRow, int startCol, int finishRow, int finishCol, int IDIM, int JDIM)
  {
    List<List<int>> dir_mat = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => 0));
    List<List<int>> closed_nodes = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => 0));
    List<List<int>> open_nodes = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => 0));
    List<Vector2> finalPath = [];

    Node pNode1, pNode2;
    int qi=0;
    int i, j, row, col, iNext, jNext;
    String c;

    List<PriorityQueue<Node>> q = [PriorityQueue<Node>((a, b) => a.FValue.compareTo(b.FValue)),PriorityQueue<Node>((a, b) => a.FValue.compareTo(b.FValue))];


    pNode1 = Node(startRow, startCol, 0, 0);
    pNode1.calculateFValue(finishRow, finishCol);
    q[qi].add(pNode1);

    while(!q[qi].isEmpty)
      {
        // get the current node w/ the lowest FValue
        // from the list of open nodes

        pNode1 = Node(q[qi].first.rowPos, q[qi].first.colPos,q[qi].first.getGValue(),q[qi].first.getFValue());

        row = pNode1.rowPos;
        col = pNode1.colPos;

        // remove the node from the open list
        q[qi].removeFirst();
        open_nodes[row][col] = 0;

        // mark it on the closed nodes list
        closed_nodes[row][col] = 1;

        // stop searching when the goal state is reached
        if (row == finishRow && col == finishCol) {
            // generate the path from finish to start from dirMap
            String path = "";
            while (!(row == startRow && col == startCol)) {
              j = dir_mat[row][col];
              c = '0' + ((j + NDIR / 2) % NDIR).toString();
              path = c + path;
              row += iDir[j];
              col += jDir[j];
              finalPath.add(Vector2(col.toDouble(), row.toDouble()));
           }

        // empty the leftover nodes
          while (!q[qi].isEmpty) q[qi].removeFirst();

            print(finalPath);
          return finalPath;
          }

        for (i = 0; i < NDIR; i++) {
          iNext = row + iDir[i];
          jNext = col + jDir[i];

          if (!(iNext < 0 || iNext > IDIM - 1 || jNext < 0 || jNext > JDIM - 1 ||
              gridMatrix[iNext][jNext] == 1 || closed_nodes[iNext][jNext] == 1)) {

            pNode2 = Node(iNext, jNext, pNode1.getGValue(), pNode1.getFValue());
              pNode2.updateGValue(i);
              pNode2.calculateFValue(finishRow, finishCol);


            if (open_nodes[iNext][jNext] == 0) {
                open_nodes[iNext][jNext] = pNode2.getFValue();
                q[qi].add(pNode2);

                dir_mat[iNext][jNext] = ((i + NDIR / 2) % NDIR).toInt();
              }
            else if (open_nodes[iNext][jNext] > pNode2.getFValue()) {
              open_nodes[iNext][jNext] = pNode2.getFValue();
              dir_mat[iNext][jNext] = ((i + NDIR / 2) % NDIR).toInt();

              while (!(q[qi].first.rowPos == iNext &&
                  q[qi].first.colPos == jNext)) {
                q[1 - qi].add(q[qi].first);
                q[qi].removeFirst();
              }

              q[qi].removeFirst();

              if (q[qi].length > q[1 - qi].length) {qi = 1 - qi;}

              while (!q[qi].isEmpty) {
                q[1 - qi].add(q[qi].first);
                q[qi].removeFirst();
              }
              qi = 1 - qi;

              q[qi].add(pNode2);

            }
          }
        }


      }

      return [];
  }
}