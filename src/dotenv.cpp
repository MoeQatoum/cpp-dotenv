#include "dotenv.h"

#include "Parser.h"
#include "environ.h"

#include <fstream>
#include <utility>

using namespace std;
namespace dotenv
{

    dotenv &dotenv::load_dotenv(const string &dotenv_path, const bool overwrite, const bool interpolate)
    {
        ifstream env_file;
        env_file.open(dotenv_path);

        if (env_file.good())
        {
            Parser parser;
            parser.parse(env_file, overwrite, interpolate);
            env_file.close();
        }

        return *this;
    }

    const dotenv::value_type dotenv::operator[](const key_type &k) const { return getenv(k).second; }

    dotenv &dotenv::instance() { return _instance; }

    const string dotenv::env_filename = ".env";
    dotenv dotenv::_instance;

    dotenv &env = dotenv::instance();

}; // namespace dotenv
