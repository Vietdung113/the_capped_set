// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CappedSet {
    uint256 public numElements;
    struct element {
        address addr;
        uint256 value;
    }
    element[] public heap;
    mapping(address => uint256) public addressToIndex;

    event Insert(address addr, uint256 value);
    event Remove(address addr, uint256 value);
    event Update(address addr, uint256 value);

    constructor(uint256 _numElements) {
        require(_numElements > 0, "Max capacity must be greater than 0");
        numElements = _numElements;
    }

    function size() external view returns (uint256) {
        return heap.length;
    }

    function insert(address addr, uint256 value) external returns (address, uint256){
        if (heap.length == numElements - 1){
            removeLowest();
        }
        heap.push(element(addr, value));
        addressToIndex[addr] = heap.length - 1;

        if (heap.length == 1){
            emit Insert(addr, value);
            return (addr, value);
        }
       // build heap
        uint256 currentIndex = heap.length - 1;

        while (currentIndex > 0) {
            uint256 parentIndex = (currentIndex - 1) / 2;
            if (heap[currentIndex].value >= heap[parentIndex].value) {
                break;
            }
            // swap
            element memory temp = heap[currentIndex];
            heap[currentIndex] = heap[parentIndex];
            heap[parentIndex] = temp;

            addressToIndex[heap[currentIndex].addr] = currentIndex;
            addressToIndex[heap[parentIndex].addr] = parentIndex;
            currentIndex = parentIndex;
        }
        address newLowestAddress = heap[0].addr;
        uint256 newLowestValue = heap[0].value;

        emit Insert(newLowestAddress, newLowestValue);

        return (newLowestAddress, newLowestValue);
    }

    function update(address addr, uint256 value) external returns (address, uint256) {
        require(heap.length > 0, "Heap is empty");
        require(addressToIndex[addr] < heap.length, "Element not found in heap");

        uint256 index = addressToIndex[addr];
        uint256 oldValue = heap[index].value;
        heap[index].value = value;

        emit Update(addr, value);
        if (value < oldValue) {
            // Heapify upwards
            while (index > 0) {
                uint256 parentIndex = (index - 1) / 2;
                if (heap[index].value >= heap[parentIndex].value) {
                    break;
                }
                // swap
                element memory temp = heap[index];
                heap[index] = heap[parentIndex];
                heap[parentIndex] = temp;

                addressToIndex[heap[index].addr] = index;
                addressToIndex[heap[parentIndex].addr] = parentIndex;

                index = parentIndex;
            }
        } else {
            // Heapify downwards
            uint256 currentIndex = index;
            while (true) {
                uint256 leftChildIndex = 2 * currentIndex + 1;
                uint256 rightChildIndex = 2 * currentIndex + 2;
                if (leftChildIndex >= heap.length) {
                    break;
                }
                uint256 smallestChildIndex = leftChildIndex;
                if (
                    rightChildIndex < heap.length &&
                    heap[rightChildIndex].value < heap[leftChildIndex].value
                ) {
                    smallestChildIndex = rightChildIndex;
                }
                if (heap[smallestChildIndex].value >= heap[currentIndex].value) {
                    break;
                }
                // swap
                element memory temp = heap[currentIndex];
                heap[currentIndex] = heap[smallestChildIndex];
                heap[smallestChildIndex] = temp;

                addressToIndex[heap[currentIndex].addr] = currentIndex;
                addressToIndex[heap[smallestChildIndex].addr] = smallestChildIndex;

                currentIndex = smallestChildIndex;
            }
        }

        address newLowestAddress = heap[0].addr;
        uint256 newLowestValue = heap[0].value;
        // Return the updated values
        return (newLowestAddress, newLowestValue);
    }

    function getLowest() external view returns (address, uint256) {
        require(heap.length > 0, "Heap is empty");
        return (heap[0].addr, heap[0].value);
    }

    function removeLowest() internal returns (address, uint256) {
        require(heap.length > 0, "Heap is empty");
        address lowestAddress = heap[0].addr;
        uint256 lowestValue = heap[0].value;
        delete addressToIndex[lowestAddress];


        heap[0] = heap[heap.length - 1];
        heap.pop();
        emit Remove(lowestAddress, lowestValue);

        if (heap.length > 0){
            addressToIndex[heap[0].addr] = 0;
            uint256 currentIndex = 0;
            while (true) {
                uint256 leftChildIndex = 2 * currentIndex + 1;
                uint256 rightChildIndex = 2 * currentIndex + 2;
                if (leftChildIndex >= heap.length) {
                    break;
                }
                uint256 smallestChildIndex = leftChildIndex;
                if (
                    rightChildIndex < heap.length &&
                    heap[rightChildIndex].value < heap[leftChildIndex].value
                ) {
                    smallestChildIndex = rightChildIndex;
                }
                if (heap[smallestChildIndex].value >= heap[currentIndex].value) {
                    break;
                }
                // swap
                element memory temp = heap[currentIndex];
                heap[currentIndex] = heap[smallestChildIndex];
                heap[smallestChildIndex] = temp;

                addressToIndex[heap[currentIndex].addr] = currentIndex;
                addressToIndex[heap[smallestChildIndex].addr] = smallestChildIndex;
                currentIndex = smallestChildIndex;
            }
        }
        return (lowestAddress, lowestValue);
    }

    function getValue(address addr) public view returns (uint256) {
        require(addressToIndex[addr] < heap.length, "Element not found in heap");
        return heap[addressToIndex[addr]].value;
    }

}
