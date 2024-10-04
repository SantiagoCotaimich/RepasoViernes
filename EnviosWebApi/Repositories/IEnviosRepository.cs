using EnviosWebApi.Models;

namespace EnviosWebApi.Repositories
{
    public interface IEnviosRepository
    {
        bool Create(TEnvio envio);

        bool Delete( int id );

        List<TEnvio> GetByDates(DateTime? fechaInicio, DateTime? fechaFin);

        TEnvio? GetById(int id);
    }
}
