# ===============================================================================
#
# PROGRAMMERS:
#
# jean-romain.roussel.1@ulaval.ca  -  https://github.com/Jean-Romain/lidR
#
# COPYRIGHT:
#
# Copyright 2016 Jean-Romain Roussel
#
# This file is part of lidR R package.
#
# lidR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# ===============================================================================



#' Build a catalog of las tiles/files
#'
#' Build a \code{Catalog} object from a folder name. A catalog is the representation of a set
#' of las files. A computer cannot load all the data at the same time. A catalog is a simple
#' way to manage all the file sequentially reading only the headers.
#' @param folder string. The path of a folder containing a set of .las files
#' @param \dots Extra parameters to \link[base:list.files]{list.files}. Typically `recursive = TRUE`.
#' @seealso
#' \link[lidR:plot.Catalog]{plot}
#' \link[lidR:catalog_apply]{catalog_apply}
#' \link[lidR:catalog_queries]{catalog_queries}
#' @return A data.frame with the class Catalog
#' @export
catalog = function(folder, ...)
{
  if (!is.character(folder))
    stop("'folder' must be a character string")

  finfo <- file.info(folder)

  if (all(!finfo$isdir))
    files <- folder
  else if (!dir.exists(folder))
    stop(paste(folder, " does not exist"))
  else
    files <- list.files(folder, full.names = T, pattern = "(?i)\\.la(s|z)$", ...)

  verbose("Reading files...")

  headers <- lapply(files, function(x)
  {
    header <- rlas::readlasheader(x)
    header$`Variable Length Records` <- NULL
    return(as.data.frame(header))
  })

  headers <- do.call(rbind.data.frame, headers)
  headers$filename <- files
  rownames(headers) <- NULL

  class(headers) <- append("Catalog", class(headers))

  return(headers)
}
