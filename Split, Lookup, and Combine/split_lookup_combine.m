let
    fn_SplitLookupCombine = (ListContent as any, SplitDelimiter as text, LookupKeyType as type, LookupTable as table, LookupColumnName as text, JoinDelimiter as nullable text) => 
    let
        Source = ListContent,
        #"JoinDelim" = if JoinDelimiter <> null then JoinDelimiter else SplitDelimiter,
        #"Split Text" = if Source <> null then Text.Split(Source, SplitDelimiter) else { null },
        #"Converted to Table" = Table.FromList(#"Split Text", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Changed Type" = Table.TransformColumnTypes(#"Converted to Table",{{"Column1", LookupKeyType}}),
        #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"Column1"}, LookupTable, {LookupColumnName}, "Lookup", JoinKind.LeftOuter),
        #"Expanded Lookup" = Table.ExpandTableColumn(#"Merged Queries", "Lookup", {"Value"}, {"Lookup.Value"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded Lookup",{"Column1"}),
        #"Converted to List" = Table.ToList(#"Removed Columns", Combiner.CombineTextByDelimiter("", QuoteStyle.None)),
        #"Combined Text" = Text.Combine(#"Converted to List", #"JoinDelim")
    in
        #"Combined Text"
in
    fn_SplitLookupCombine