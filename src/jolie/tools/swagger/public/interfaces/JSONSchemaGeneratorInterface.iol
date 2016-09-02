/****************************************************************************
  Copyright 2010 by Claudio Guidi <cguidi@italianasoftware.com>
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
********************************************************************************/

include "types/role_types.iol"

type GetSchemasResponse: void {
  .definitions*: undefined
}

interface JSONSchemaGeneratorInterface {
 RequestResponse:
   getSchemas( Interface )( GetSchemasResponse ),
   getType( Type )( undefined ),
   getTypeInLine( Type )( undefined ),
   getSubType( SubType )( undefined ),
   getNativeType( NativeType )( undefined )
}
