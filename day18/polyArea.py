def polygonArea(verts):
 
    # Initialize area
    area = 0.0
 
    # Calculate value of shoelace formula
    n = len(verts)
    j = n - 1
    for i in range(0,n):
        area += (verts[j][0] + verts[i][0]) * (verts[j][1] - verts[i][1])
        j = i   # j is previous vertex to i
     
 
    # Return absolute value
    return int(abs(area / 2.0))
 

verts = [[461938, 1], [461938, -56406], [818609, -56406], [818609, -919646], [1186329, -919646], [1186329, -1186328], [609066, -1186328], [609066, -356353], [497057, -356353], [497057, -1186328], [5411, -1186328], [5411, -500254], [0, -500254], [0, 1]]

print(polygonArea(verts))
