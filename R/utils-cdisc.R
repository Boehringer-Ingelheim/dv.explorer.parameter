# YT#VH8a89ea446670a3a234ad6be186089cf1#VH00000000000000000000000000000000#

# CDISC dictates that Study Days should skip day 0 on both SDTM and ADAM datasets.
# The first Study Day is day 1. The one before is day -1.
# Converting to and from this representation and one that admits 0 only requires
# the offsetting of non-negative days by +1/-1.

CD <- local({
  list(
    to_CDISC_days = function(days) days + (days >= 0),
    from_CDISC_days = function(days) days - (days >= 0)
  )
})
