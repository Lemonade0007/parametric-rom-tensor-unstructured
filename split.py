class Point:
    def __init__(self, x, y, id):
        self.x = x
        self.y = y
        self.id = id

def read_points_from_file(file_path):
    """
    Read points from a file, each line representing a point.
    Format: x y
    Assign a unique ID to each point.
    """
    points = []
    with open(file_path, 'r') as file:
        for id, line in enumerate(file):
            x, y = map(float, line.split())
            points.append(Point(x, y, id))
    return points

def split_points(points, axis):
    """
    Split points into two groups based on the median along the specified axis (x or y).
    If the groups are of unequal size, duplicate the last point of the smaller group.
    """
    points.sort(key=lambda p: p.x if axis == 'x' else p.y)
    mid = len(points) // 2
    left = points[:mid]
    right = points[mid:]

    # Duplicate the last point of the smaller group if the groups are of unequal size
    if len(left) != len(right):
        if len(left) < len(right):
            left.append(left[-1])
        else:
            right.append(right[-1])

    return left, right

def build_matrix(points, axis='x'):
    """
    Build the transfer matrix from the given points.
    Return 1x1 matrix if there's only one point.
    Otherwise, split the point set along the current axis, recursively build submatrices, and merge them.
    """
    if len(points) == 1:
        return [[points[0].id]]

    # Split the point set
    left_points, right_points = split_points(points, axis)
    next_axis = 'y' if axis == 'x' else 'x'

    # Recursively build submatrices
    left_matrix = build_matrix(left_points, next_axis)
    right_matrix = build_matrix(right_points, next_axis)

    # Merge matrices
    if axis == 'x':
        # Merge horizontally
        return [left_row + right_row for left_row, right_row in zip(left_matrix, right_matrix)]
    else:
        # Merge vertically
        return left_matrix + right_matrix

def print_matrix(matrix, path):
    """
    Print the matrix.
    """
    with open(path, 'w') as file:
        for row in matrix:
            file.write(','.join(map(str, row)) + '\n')

points = read_points_from_file("preprocessed/point(2).txt") # Your file here

matrix = build_matrix(points)

print_matrix(matrix, "transmatrix(2).txt") # Output file