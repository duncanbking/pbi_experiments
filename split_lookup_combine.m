let
    Source = (ListContent as any) => let
        Source = ListContent,
        #"Split Text" = if Source <> null then Text.Split(Source, "|") else { null },
        #"Converted to Table" = Table.FromList(#"Split Text", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Changed Type" = Table.TransformColumnTypes(#"Converted to Table",{{"Column1", Int64.Type}}),
        #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"Column1"}, Lookup, {"ID"}, "Lookup", JoinKind.LeftOuter),
        #"Expanded Lookup" = Table.ExpandTableColumn(#"Merged Queries", "Lookup", {"Value"}, {"Lookup.Value"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded Lookup",{"Column1"}),
        #"Converted to List" = Table.ToList(#"Removed Columns"),
        #"Combined Text" = Text.Combine(#"Converted to List", "|")
    in
        #"Combined Text"
in
    Source