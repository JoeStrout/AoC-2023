// Min-First Priority Heap Implementation
// This is very similar to the Python "heapq" module
// (https://docs.python.org/3/library/heapq.html).
// Usage:
//
//	1. Create your "heap" as an empty list:
//		h = []
//	2. To insert an item, do:
//		heapq.heapPush h, 42
//	3. To get the next lowest value back out, do:
//		result = heapq.heapPop(h)
//	4. If you just want to peek at the lowest value,
//		that's always at h[0] for a given heap h.
//
// If needed, you can specify a key by which to compare
// the values (just like the optional parameter to list.sort).
// This can be a list index or a map key.

heapPush = function(heap, value, comparisonKey=null)
    // Insert the value at the end of the heap
    heap.push value
    // Move the value to its correct position
    heapifyUp heap, heap.len - 1, comparisonKey
end function

heapPop = function(heap, comparisonKey=null)
    if heap.len == 0 then return null
    minVal = heap[0]

    if heap.len > 1 then
        // Replace the root of the heap with the last element
        heap[0] = heap.pop
        // Reorganize the heap
        heapifyDown heap, 0, comparisonKey
    else
        // If only one element was left, just remove it
        heap.pop
    end if
    
    return minVal
end function

heapPushPop = function(heap, value, comparisonKey=null)
    if not heap or value <= heap[0] then
        // If the heap is empty or the value is smaller than the minimum, 
        // just insert and pop immediately
        return value
    else
        // Replace the root with the new value, and heapify down
        minVal = heap[0]
        heap[0] = value
        heapifyDown heap, 0, comparisonKey
        return minVal
    end if
end function

heapifyUp = function(heap, index, comparisonKey)
    while index > 0
        parentIndex = (index - 1) / 2
        if comparisonKey == null then        
			if heap[index] >= heap[parentIndex] then break
			swap heap, index, parentIndex
			index = parentIndex
		else
			if heap[index][comparisonKey] >= heap[parentIndex][comparisonKey] then break
			swap heap, index, parentIndex
			index = parentIndex
        end if
    end while
end function

heapifyDown = function(heap, index, comparisonKey)
    lastIndex = heap.len - 1
    while true
        leftChildIndex = 2 * index + 1
        rightChildIndex = 2 * index + 2
        smallest = index

		if comparisonKey == null then
			if leftChildIndex <= lastIndex and heap[leftChildIndex] < heap[smallest] then
				smallest = leftChildIndex
			end if
			if rightChildIndex <= lastIndex and heap[rightChildIndex] < heap[smallest] then
				smallest = rightChildIndex
			end if
		else
			if leftChildIndex <= lastIndex and heap[leftChildIndex][comparisonKey] < heap[smallest][comparisonKey] then
				smallest = leftChildIndex
			end if
			if rightChildIndex <= lastIndex and heap[rightChildIndex][comparisonKey] < heap[smallest][comparisonKey] then
				smallest = rightChildIndex
			end if
		end if

        if smallest != index then
            swap heap, index, smallest
            index = smallest
        else
            break
        end if
    end while
end function

swap = function(heap, i, j)
    temp = heap[i]
    heap[i] = heap[j]
    heap[j] = temp
end function
