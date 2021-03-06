% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rules.R
\name{compose_rules}
\alias{compose_rules}
\title{Combine shinyvalidate rule functions}
\usage{
compose_rules(...)
}
\arguments{
\item{...}{Any number of shinyvalidate rule functions; earlier rules will be
attempted before later rules. Argument names are ignored. Single-sided
formulas are also accepted instead of a function, using \code{.} as the variable
name for the input value.}
}
\value{
A function suitable for use as an
\code{\link[=InputValidator]{InputValidator$add_rule()}} rule.
}
\description{
Takes multiple shinyvalidate rule functions, and returns a shinyvalidate rule
function. When this resulting rule function is invoked, it will try each of
its constituent rule functions in order; the first validation error that is
detected will be returned immediately and the remaining rules will not be
tried.

This function is not intended to be used by Shiny app authors (i.e. not for
\code{InputValidator$add_rule("x", compose_rules(...))}), but for developers of
reusable shinyvalidate rule functions. See examples.
}
\examples{
# Create a new shinyvalidate rule that is composed
# of two `sv_*()` rule functions (`sv_integer()` and
# `sv_gt()`, and a custom function for ensuring
# a number is even)
positive_even_integer <- function() {
  compose_rules(
    sv_integer(),
    sv_gt(0),
    ~ if (. \%\% 2 == 1) "Must be an even number"
  )
}

# Use the `positive_even_integer()` rule function
# to check that a supplied value is an integer, greater
# than zero, and even (in that order)

## Only run examples in interactive R sessions
if (interactive()) {

library(shiny)
library(shinyvalidate)

ui <- fluidPage(
  textInput("value", "Value")
)

server <- function(input, output, session) {
  
  # Validation rules are set in the server, start by
  # making a new instance of an `InputValidator()`
  iv <- InputValidator$new()

  # Add two `add_rule()` statements: one that
  # combines `sv_required()` and `sv_numeric()` in
  # single rule, and another that is defined
  # through the use of `compose_rules()`
  iv$add_rule("value", compose_rules(sv_required(), sv_numeric()))
  iv$add_rule("value", positive_even_integer())

  # Finally, `enable()` the validation rules
  iv$enable()
}

shinyApp(ui, server)

}

}
\seealso{
Other rule functions: 
\code{\link{sv_between}()},
\code{\link{sv_email}()},
\code{\link{sv_equal}()},
\code{\link{sv_gte}()},
\code{\link{sv_gt}()},
\code{\link{sv_in_set}()},
\code{\link{sv_integer}()},
\code{\link{sv_lte}()},
\code{\link{sv_lt}()},
\code{\link{sv_not_equal}()},
\code{\link{sv_numeric}()},
\code{\link{sv_optional}()},
\code{\link{sv_regex}()},
\code{\link{sv_required}()},
\code{\link{sv_url}()}
}
\concept{rule functions}
