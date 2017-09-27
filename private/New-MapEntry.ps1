function New-MapEntry{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [HashTable]$HashTable
    )
    $HashTable.GetEnumerator() | ForEach-Object{
        $MapEntry = [VMware.Hv.MapEntry]::new()
        $MapEntry.Key = $_.Key
        $MapEntry.Value = $_.Value
        Write-Output $MapEntry
    }
    Return
}