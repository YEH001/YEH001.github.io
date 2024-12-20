## Leetcode刷题

### 分割数组

长度为 n 的数组分成长度为 k 的子数组的问题

#### 简单嵌套法

#### 滑动窗口法

#### 索引数组法

### 动态规划

#### KMP字符串匹配

### 寻路算法

#### A*算法

```
#include <vector>
#include <queue>
#include <cmath>
#include <algorithm>

struct Node {
    int x, y;
    int f, g, h;  // f = g + h
    Node* parent;
    
    Node(int x, int y) : x(x), y(y), f(0), g(0), h(0), parent(nullptr) {}
};

struct CompareNode {
    bool operator()(const Node* a, const Node* b) {
        return a->f > b->f;
    }
};

class AStar {
private:
   std::vector<std::vector<int>> grid;
   int rows, cols;
   std::vector<std::pair<int, int>> directions{{-1,0}, {1,0}, {0,-1}, {0,1}};
public:
   // 添加构造函数，创建空地图
   AStar(int rows, int cols) : rows(rows), cols(cols) {
       grid = std::vector<std::vector<int>>(rows, std::vector<int>(cols, 0));
   }
   
   // 添加设置障碍物的方法
   void setObstacle(int x, int y) {
       if (isValidPosition(x, y)) {
           grid[x][y] = 1;
       }
   }
   
   // 添加移除障碍物的方法
   void removeObstacle(int x, int y) {
       if (isValidPosition(x, y)) {
           grid[x][y] = 0;
       }
   }
   
   // 添加清除所有障碍物的方法
   void clearObstacles() {
       for (int i = 0; i < rows; i++) {
           for (int j = 0; j < cols; j++) {
               grid[i][j] = 0;
           }
       }
   }
   // 添加检查位置是否有障碍物的方法
   bool hasObstacle(int x, int y) const {
       if (isValidPosition(x, y)) {
           return grid[x][y] == 1;
       }
       return true; // 地图外的位置视为障碍
   }
   
private:
   // 检查位置是否在地图范围内
   bool isValidPosition(int x, int y) const {
       return x >= 0 && x < rows && y >= 0 && y < cols;
   }
public:
    int calculateH(int x, int y, int endX, int endY) {
        // 使用曼哈顿距离作为启发函数
        return std::abs(x - endX) + std::abs(y - endY);
    }
    
    std::vector<std::pair<int, int>> findPath(int startX, int startY, int endX, int endY) {
        std::priority_queue<Node*, std::vector<Node*>, CompareNode> openList;
        std::vector<std::vector<bool>> closedList(rows, std::vector<bool>(cols, false));
        
        Node* startNode = new Node(startX, startY);
        openList.push(startNode);
        
        while (!openList.empty()) {
            Node* current = openList.top();
            openList.pop();
            
            if (current->x == endX && current->y == endY) {
                return reconstructPath(current);
            }
            
            closedList[current->x][current->y] = true;
            
            // 检查四个方向的相邻节点
            for (const auto& dir : directions) {
                int newX = current->x + dir.first;
                int newY = current->y + dir.second;
                
                if (newX < 0 || newX >= rows || newY < 0 || newY >= cols ||
                    grid[newX][newY] == 1 || closedList[newX][newY]) {
                    continue;
                }
                
                int newG = current->g + 1;
                Node* neighbor = new Node(newX, newY);
                neighbor->g = newG;
                neighbor->h = calculateH(newX, newY, endX, endY);
                neighbor->f = neighbor->g + neighbor->h;
                neighbor->parent = current;
                
                openList.push(neighbor);
            }
        }
        
        return std::vector<std::pair<int, int>>();  // 没找到路径
    }
    
private:
    std::vector<std::pair<int, int>> reconstructPath(Node* endNode) {
        std::vector<std::pair<int, int>> path;
        Node* current = endNode;
        
        while (current != nullptr) {
            path.push_back({current->x, current->y});
            current = current->parent;
        }
        
        std::reverse(path.begin(), path.end());
        return path;
    }
};
```

