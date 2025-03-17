# YT#VH638a72c72d9f92f83515aa05a98751f7#VH00000000000000000000000000000000#
CD <- local({
  # CDISC dictates that Study Days should skip day 0 on both SDTM and ADAM datasets.
  # The first Study Day is day 1. The one before is day -1.
  # Converting to and from this representation and one that admits 0 only requires
  # the offsetting of non-negative days by +1/-1.
  list(
    to_CDISC_days = function(days) days + (days >= 0),
    from_CDISC_days = function(days) days - (days >= 0)
  )
})
