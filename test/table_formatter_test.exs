defmodule TableFormatterTest do
    use ExUnit.Case
    import ExUnit.CaptureIO
    alias Issues.TableFormatter, as: TF

    @simple_test_data [
 
        [ c1: "r1c1", c2: "r1c2", c3: "r1c3", c4: "r1+++c4" ],
         
        [ c1: "r2c1", c2: "r2c2", c3: "r2c3", c4: "r2c4" ],
         
        [ c1: "r3c1", c2: "r3c2", c3: "r3c3", c4: "r3c4" ],
         
        [ c1: "r4c1", c2: "r4++c2", c3: "r4c3", c4: "r4c4" ]
         
        ]
    @headers [:c1, :c2, :c4]
    def split_with_three_columns do
        TF.split_into_columns(@simple_test_data, @headers)
    end
    test "split_into_columns" do
        columns = split_with_three_columns()
        assert length(columns) == length(@headers)
        assert List.first(columns) == ["r1 c1" , "r2 c1" , "r3 c1" , "r4 c1"]
        assert List.last(columns) == ["r1+++c4" , "r2 c4" , "r3 c4" , "r4 c4"]
    end
    test "columns_widths" do
        widths = TF.widths_of(split_with_three_columns())
        assert widths == [5, 6, 7]
    end
    test "correct format string returned" do
        assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
    end
    test "Output is correct" do
        result = capture_io fn ->
            TF.print_table_for_columns(@simple_test_data, @headers)
    end
    assert result == """
            c1 | c2 | c4 
        
        ------+--------+-------- 
        
        r1 c1 | r1 c2 | r1+++c4 
        
        r2 c1 | r2 c2 | r2 c4 
        
        r3 c1 | r3 c2 | r3 c4 
        
        r4 c1 | r4++c2 | r4 c4
    """
end
end