% Rectangle.m
% This serves a brief example of Object Oriented Programming 
classdef Rectangle
    properties
        Length
        Width
    end
    
    methods
        % Constructor
        function obj = Rectangle(length, width)
            if nargin > 0
                obj.Length = length;
                obj.Width = width;
            end
        end
        
        % Method to calculate the area of the rectangle
        function area = getArea(obj)
            area = obj.Length * obj.Width;
        end
        
        % Method to calculate the perimeter of the rectangle
        function perimeter = getPerimeter(obj)
            perimeter = 2 * (obj.Length + obj.Width);
        end
    end
end
